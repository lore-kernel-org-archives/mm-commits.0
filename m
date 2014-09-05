From: akpm@linux-foundation.org
Subject: +
 binfmt_misc-expand-the-register-format-limit-to-1920-bytes.patch added to
 -mm tree
Date: Fri, 05 Sep 2014 16:06:28 -0700
Message-ID: <540a41f4.sH6Ne1nVEltWRaAp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaIEXG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 19:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: expand the register format limit to 1920 bytes
has been added to the -mm tree.  Its filename is
     binfmt_misc-expand-the-register-format-limit-to-1920-bytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_misc-expand-the-register-format-limit-to-1920-bytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_misc-expand-the-register-format-limit-to-1920-bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: binfmt_misc: expand the register format limit to 1920 bytes

The current code places a 256 byte limit on the registration format.  This
ends up being fairly limited when you try to do matching against a binary
format like ELF:

 - the magic & mask formats cannot have any embedded NUL chars
   (string_unescape_inplace halts at the first NUL)
 - each escape sequence quadruples the size: \x00 is needed for NUL
 - trying to match bytes at the start of the file as well as further
   on leads to a lot of \x00 sequences in the mask
 - magic & mask have to be the same length (when decoded)
 - still need bytes for the other fields
 - impossible!

Let's look at a concrete (and common) example: using QEMU to run MIPS
ELFs.  The name field uses 11 bytes "qemu-mipsel".  The interp uses 20
bytes "/usr/bin/qemu-mipsel".  The type & flags takes up 4 bytes.  We need
7 bytes for the delimiter (usually ":").  We can skip offset.  So already
we're down to 107 bytes to use with the magic/mask instead of the real
limit of 128 (BINPRM_BUF_SIZE).  If people use shell code to register
(which they do the majority of the time), they're down to ~26 possible
bytes since the escape sequence must be \x##.

The ELF format looks like (both 32 & 64 bit):

	e_ident: 16 bytes
	e_type: 2 bytes
	e_machine: 2 bytes

Those 20 bytes are enough for most architectures because they have so few
formats in the first place, thus they can be uniquely identified.  That
also means for shell users, since 20 is smaller than 26, they can sanely
register a handler.

But for some targets (like MIPS), we need to poke further.  The ELF fields
continue on:

	e_entry: 4 or 8 bytes
	e_phoff: 4 or 8 bytes
	e_shoff: 4 or 8 bytes
	e_flags: 4 bytes

We only care about e_flags here as that includes the bits to identify
whether the ELF is O32/N32/N64.  But now we have to consume another 16
bytes (for 32 bit ELFs) or 28 bytes (for 64 bit ELFs) just to match the
flags.  If every byte is escaped, we send 288 more bytes to the kernel
((20 {e_ident,e_type,e_machine} + 12 {e_entry,e_phoff,e_shoff} + 4
{e_flags}) * 2 {mask,magic} * 4 {escape}) and we've clearly blown our
budget.

Even if we try to be clever and do the decoding ourselves (rather than
relying on the kernel to process \x##), we still can't hit the mark --
string_unescape_inplace treats mask & magic as C strings so NUL cannot
be embedded.  That leaves us with having to pass \x00 for the 12/24
entry/phoff/shoff bytes (as those will be completely random addresses),
and that is a minimum requirement of 48/96 bytes for the mask alone.
Add up the rest and we blow through it (this is for 64 bit ELFs):
magic: 20 {e_ident,e_type,e_machine} + 24 {e_entry,e_phoff,e_shoff} +
       4 {e_flags} = 48              # ^^ See note below.
mask: 20 {e_ident,e_type,e_machine} + 96 {e_entry,e_phoff,e_shoff} +
       4 {e_flags} = 120
Remember above we had 107 left over, and now we're at 168.  This is of
course the *best* case scenario -- you'll also want to have NUL bytes
in the magic & mask too to match literal zeros.

Note: the reason we can use 24 in the magic is that we can work off of the
fact that for bytes the mask would clobber, we can stuff any value into
magic that we want.  So when mask is \x00, we don't need the magic to also
be \x00, it can be an unescaped raw byte like '!'.  This lets us handle
more formats (barely) under the current 256 limit, but that's a pretty
tall hoop to force people to jump through.

With all that said, let's bump the limit from 256 bytes to 1920.  This way
we support escaping every byte of the mask & magic field (which is 1024
bytes by themselves -- 128 * 4 * 2), and we leave plenty of room for other
fields.  Like long paths to the interpreter (when you have source in your
/really/long/homedir/qemu/foo).  Since the current code stuffs more than
one structure into the same buffer, we leave a bit of space to easily
round up to 2k.  1920 is just as arbitrary as 256 ;).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/binfmt_misc.txt |    2 +-
 fs/binfmt_misc.c              |   19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN Documentation/binfmt_misc.txt~binfmt_misc-expand-the-register-format-limit-to-1920-bytes Documentation/binfmt_misc.txt
--- a/Documentation/binfmt_misc.txt~binfmt_misc-expand-the-register-format-limit-to-1920-bytes
+++ a/Documentation/binfmt_misc.txt
@@ -58,7 +58,7 @@ Here is what the fields mean:
 
 
 There are some restrictions:
- - the whole register string may not exceed 255 characters
+ - the whole register string may not exceed 1920 characters
  - the magic must reside in the first 128 bytes of the file, i.e.
    offset+size(magic) has to be less than 128
  - the interpreter string may not exceed 127 characters
diff -puN fs/binfmt_misc.c~binfmt_misc-expand-the-register-format-limit-to-1920-bytes fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-expand-the-register-format-limit-to-1920-bytes
+++ a/fs/binfmt_misc.c
@@ -62,7 +62,22 @@ static struct file_system_type bm_fs_typ
 static struct vfsmount *bm_mnt;
 static int entry_count;
 
-/* 
+/*
+ * Max length of the register string.  Determined by:
+ *  - 7 delimiters
+ *  - name:   ~50 bytes
+ *  - type:   1 byte
+ *  - offset: 3 bytes (has to be smaller than BINPRM_BUF_SIZE)
+ *  - magic:  128 bytes (512 in escaped form)
+ *  - mask:   128 bytes (512 in escaped form)
+ *  - interp: ~50 bytes
+ *  - flags:  5 bytes
+ * Round that up a bit, and then back off to hold the internal data
+ * (like struct Node).
+ */
+#define MAX_REGISTER_LENGTH 1920
+
+/*
  * Check if we support the binfmt
  * if we do, return the node, else NULL
  * locking is done in load_misc_binary
@@ -279,7 +294,7 @@ static Node *create_entry(const char __u
 
 	/* some sanity checks */
 	err = -EINVAL;
-	if ((count < 11) || (count > 256))
+	if ((count < 11) || (count > MAX_REGISTER_LENGTH))
 		goto out;
 
 	err = -ENOMEM;
_

Patches currently in -mm which might be from vapier@gentoo.org are

vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
binfmt_misc-expand-the-register-format-limit-to-1920-bytes.patch
binfmt_misc-touch-up-documentation-a-bit.patch
linux-next.patch

