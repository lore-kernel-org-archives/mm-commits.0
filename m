From: akpm@linux-foundation.org
Subject: + fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch added to -mm tree
Date: Mon, 29 Jun 2009 16:28:12 -0700
Message-ID: <200906292328.n5TNSCNK007456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755137AbZF2X25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 19:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, mingo@elte.hu, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk


The patch titled
     fs: fix overflow in sys_mount() for in-kernel calls
has been added to the -mm tree.  Its filename is
     fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: fix overflow in sys_mount() for in-kernel calls
From: Vegard Nossum <vegard.nossum@gmail.com>

On 2009/6/17 Ingo Molnar <mingo@elte.hu> reported:
>
> btw., here's an old friend of a warning:
>
> async_continuing @ 1 after 0 usec
> WARNING: kmemcheck: Caught 8-bit read from freed memory (f5f33004)
> 0040f3f57400686f74706c756700000000000000000000000000000000000000
>  i i i i f f f f f f f f f f f f f f f f f f f f f f f f f f f f
>          ^
>
> Pid: 1, comm: swapper Not tainted (2.6.30-tip-04303-g5ada65e-dirty #767) P4DC6
> EIP: 0060:[<c1248df4>] EFLAGS: 00010246 CPU: 0
> EIP is at exact_copy_from_user+0x64/0x130
> EAX: 00000000 EBX: 00000001 ECX: 000000f5 EDX: 000000f5
> ESI: f5fdeffb EDI: f5f33004 EBP: f6c48ee8 ESP: c29598cc
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: f6c20044 CR3: 0294d000 CR4: 000006d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff4ff0 DR7: 00000400
>  [<c124916a>] copy_mount_options+0xba/0x1c0
>  [<c124dc0a>] sys_mount+0x1a/0x170
>  [<c263c937>] do_mount_root+0x27/0xe0
>  [<c263ca33>] mount_block_root+0x43/0x140
>  [<c263cc02>] mount_root+0xd2/0x160
>  [<c263ce49>] prepare_namespace+0x1b9/0x380
>  [<c263c4c8>] kernel_init+0xb8/0x110
>  [<c103ab13>] kernel_thread_helper+0x7/0x14
>  [<ffffffff>] 0xffffffff
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.

sys_mount() reads/copies a whole page for its "type" parameter.  When
do_mount_root() passes a kernel address that points to an object which is
smaller than a whole page, copy_mount_options() will happily go past this
memory object, possibly dereferencing "wild" pointers that could be in any
state (hence the kmemcheck warning, which shows that parts of the next
page are not even allocated).

(The likelyhood of something going wrong here is pretty low -- first of
all this only applies to kernel calls to sys_mount(), which are mostly
found in the boot code.  Secondly, I guess if the page was not mapped,
exact_copy_from_user() _would_ in fact handle it correctly because of its
access_ok(), etc.  checks.)

But it is much nicer to avoid the dubious reads altogether, by stopping as
soon as we find a NUL byte.  Is there a good reason why we can't do
something like this, using the already existing strndup_from_user()?

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   81 ++++++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 32 deletions(-)

diff -puN fs/namespace.c~fs-fix-overflow-in-sys_mount-for-in-kernel-calls fs/namespace.c
--- a/fs/namespace.c~fs-fix-overflow-in-sys_mount-for-in-kernel-calls
+++ a/fs/namespace.c
@@ -1638,7 +1638,7 @@ static int do_new_mount(struct path *pat
 {
 	struct vfsmount *mnt;
 
-	if (!type || !memchr(type, 0, PAGE_SIZE))
+	if (!type)
 		return -EINVAL;
 
 	/* we need capabilities... */
@@ -1869,6 +1869,23 @@ int copy_mount_options(const void __user
 	return 0;
 }
 
+int copy_mount_string(const void __user *data, char **where)
+{
+	char *tmp;
+
+	if (!data) {
+		*where = NULL;
+		return 0;
+	}
+
+	tmp = strndup_user(data, PAGE_SIZE);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+
+	*where = tmp;
+	return 0;
+}
+
 /*
  * Flags is a 32-bit value that allows up to 31 non-fs dependent flags to
  * be given to the mount() call (ie: read-only, no-dev, no-suid etc).
@@ -1898,8 +1915,6 @@ long do_mount(char *dev_name, char *dir_
 
 	if (!dir_name || !*dir_name || !memchr(dir_name, 0, PAGE_SIZE))
 		return -EINVAL;
-	if (dev_name && !memchr(dev_name, 0, PAGE_SIZE))
-		return -EINVAL;
 
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
@@ -2068,40 +2083,42 @@ EXPORT_SYMBOL(create_mnt_ns);
 SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 		char __user *, type, unsigned long, flags, void __user *, data)
 {
-	int retval;
+	int ret;
+	char *kernel_type;
+	char *kernel_dir;
+	char *kernel_dev;
 	unsigned long data_page;
-	unsigned long type_page;
-	unsigned long dev_page;
-	char *dir_page;
 
-	retval = copy_mount_options(type, &type_page);
-	if (retval < 0)
-		return retval;
+	ret = copy_mount_string(type, &kernel_type);
+	if (ret < 0)
+		goto out_type;
+
+	kernel_dir = getname(dir_name);
+	if (IS_ERR(kernel_dir)) {
+		ret = PTR_ERR(kernel_dir);
+		goto out_dir;
+	}
+
+	ret = copy_mount_string(dev_name, &kernel_dev);
+	if (ret < 0)
+		goto out_dev;
+
+	ret = copy_mount_options(data, &data_page);
+	if (ret < 0)
+		goto out_data;
 
-	dir_page = getname(dir_name);
-	retval = PTR_ERR(dir_page);
-	if (IS_ERR(dir_page))
-		goto out1;
-
-	retval = copy_mount_options(dev_name, &dev_page);
-	if (retval < 0)
-		goto out2;
-
-	retval = copy_mount_options(data, &data_page);
-	if (retval < 0)
-		goto out3;
+	ret = do_mount(kernel_dev, kernel_dir, kernel_type, flags,
+		(void *) data_page);
 
-	retval = do_mount((char *)dev_page, dir_page, (char *)type_page,
-			  flags, (void *)data_page);
 	free_page(data_page);
