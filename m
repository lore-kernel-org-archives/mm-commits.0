From: akpm@linux-foundation.org
Subject: + proc-introduce-proc_create_data-to-setup-de-data.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:55:50 -0700
Message-ID: <200804152355.m3FNtp46022481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbYDPADv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 20:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, James.Bottomley@HansenPartnership.com, Nadia.Derbey@bull.net, a.zummo@towertech.it, adobriyan@gmail.com, benh@kernel.crashing.org, bfields@fieldses.org, bjorn.helgaas@hp.com, bzolnier@gmail.com, chris.mason@oracle.com, dhowells@redhat.com, dtor@mail.ru, ebiederm@xmission.com, geert@linux-m68k.org, gregkh@suse.de, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, jeffm@suse.com, jesper.nilsson@axis.com, jgarzik@pobox.com, kkeil@suse.de, kyle@parisc-linux.org, lenb@kernel.org, mathieu.desnoyers@polymtl.ca, matthew@wil.cx, mchehab@infradead.org, mingo@elte.hu, neilb@suse.de, paulus@samba.org, peifferp@gmail.com, perex@suse.cz, petero2@telia.com, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, starvik@axis.com, tiwai@suse.de, tony.luck@intel.com, trond.myklebust@fys.uio.no


The patch titled
     proc: introduce proc_create_data to setup de->data
has been added to the -mm tree.  Its filename is
     proc-introduce-proc_create_data-to-setup-de-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: introduce proc_create_data to setup de->data
From: "Denis V. Lunev" <den@openvz.org>

This set of patches fixes an proc ->open'less usage due to ->proc_fops flip in
the most part of the kernel code.  The original OOPS is described in the
commit 2d3a4e3666325a9709cc8ea2e88151394e8f20fc:

    Typical PDE creation code looks like:
    
    	pde = create_proc_entry("foo", 0, NULL);
    	if (pde)
    		pde->proc_fops = &foo_proc_fops;
    
    Notice that PDE is first created, only then ->proc_fops is set up to
    final value. This is a problem because right after creation
    a) PDE is fully visible in /proc , and
    b) ->proc_fops are proc_file_operations which do not have ->open callback. So, it's
       possible to ->read without ->open (see one class of oopses below).
    
    The fix is new API called proc_create() which makes sure ->proc_fops are
    set up before gluing PDE to main tree. Typical new code looks like:
    
    	pde = proc_create("foo", 0, NULL, &foo_proc_fops);
    	if (!pde)
    		return -ENOMEM;
    
    Fix most networking users for a start.
    
    In the long run, create_proc_entry() for regular files will go.



In addition to this, proc_create_data is introduced to fix reading from
proc without PDE->data. The race is basically the same as above.

create_proc_entries is replaced in the entire kernel code as new method
is also simply better.


This patch:

The problem is the same as for de->proc_fops.  Right now PDE becomes visible
without data set.  So, the entry could be looked up without data.  This, in
most cases, will simply OOPS.

proc_create_data call is created to address this issue.  proc_create now
becomes a wrapper around it.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    8 +++++---
 fs/proc/root.c          |    2 +-
 include/linux/proc_fs.h |   17 +++++++++++++++--
 3 files changed, 21 insertions(+), 6 deletions(-)

diff -puN fs/proc/generic.c~proc-introduce-proc_create_data-to-setup-de-data fs/proc/generic.c
--- a/fs/proc/generic.c~proc-introduce-proc_create_data-to-setup-de-data
+++ a/fs/proc/generic.c
@@ -675,9 +675,10 @@ struct proc_dir_entry *create_proc_entry
 	return ent;
 }
 
-struct proc_dir_entry *proc_create(const char *name, mode_t mode,
-				   struct proc_dir_entry *parent,
-				   const struct file_operations *proc_fops)
+struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
+					struct proc_dir_entry *parent,
+					const struct file_operations *proc_fops,
+					void *data)
 {
 	struct proc_dir_entry *pde;
 	nlink_t nlink;
@@ -698,6 +699,7 @@ struct proc_dir_entry *proc_create(const
 	if (!pde)
 		goto out;
 	pde->proc_fops = proc_fops;
+	pde->data = data;
 	if (proc_register(parent, pde) < 0)
 		goto out_free;
 	return pde;
diff -puN fs/proc/root.c~proc-introduce-proc_create_data-to-setup-de-data fs/proc/root.c
--- a/fs/proc/root.c~proc-introduce-proc_create_data-to-setup-de-data
+++ a/fs/proc/root.c
@@ -230,5 +230,5 @@ void pid_ns_release_proc(struct pid_name
 EXPORT_SYMBOL(proc_symlink);
 EXPORT_SYMBOL(proc_mkdir);
 EXPORT_SYMBOL(create_proc_entry);
-EXPORT_SYMBOL(proc_create);
+EXPORT_SYMBOL(proc_create_data);
 EXPORT_SYMBOL(remove_proc_entry);
diff -puN include/linux/proc_fs.h~proc-introduce-proc_create_data-to-setup-de-data include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-introduce-proc_create_data-to-setup-de-data
+++ a/include/linux/proc_fs.h
@@ -116,9 +116,10 @@ void de_put(struct proc_dir_entry *de);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
-struct proc_dir_entry *proc_create(const char *name, mode_t mode,
+struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
 				struct proc_dir_entry *parent,
-				const struct file_operations *proc_fops);
+				const struct file_operations *proc_fops,
+				void *data);
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
 
 extern struct vfsmount *proc_mnt;
@@ -173,6 +174,12 @@ extern struct proc_dir_entry *proc_mkdir
 extern struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
 			struct proc_dir_entry *parent);
 
+static inline struct proc_dir_entry *proc_create(const char *name, mode_t mode,
+	struct proc_dir_entry *parent, const struct file_operations *proc_fops)
+{
+	return proc_create_data(name, mode, parent, proc_fops, NULL);
+}
+
 static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *base, 
 	read_proc_t *read_proc, void * data)
@@ -214,6 +221,12 @@ static inline struct proc_dir_entry *pro
 {
 	return NULL;
 }
+static inline struct proc_dir_entry *proc_create_data(const char *name,
+	mode_t mode, struct proc_dir_entry *parent,
+	const struct file_operations *proc_fops, void *data)
+{
+	return NULL;
+}
 #define remove_proc_entry(name, parent) do {} while (0)
 
 static inline struct proc_dir_entry *proc_symlink(const char *name,
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

