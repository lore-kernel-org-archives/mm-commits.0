From: akpm@linux-foundation.org
Subject: + add-generic-sys_old_select-fix.patch added to -mm tree
Date: Wed, 03 Feb 2010 13:00:45 -0800
Message-ID: <201002032100.o13L0je0018840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932667Ab0BCVBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 16:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, schwab@linux-m68k.org


The patch titled
     add-generic-sys_old_select-fix.txt
has been added to the -mm tree.  Its filename is
     add-generic-sys_old_select-fix.patch

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
Subject: add-generic-sys_old_select-fix.txt
From: Christoph Hellwig <hch@lst.de>

On Mon, Feb 01, 2010 at 11:40:29PM +0100, Andreas Schwab wrote:
> > Index: linux-2.6/fs/compat.c
> > ===================================================================
> > --- linux-2.6.orig/fs/compat.c	2010-01-12 14:08:16.202003005 +0100
> > +++ linux-2.6/fs/compat.c	2010-01-29 23:35:20.187003404 +0100
> > @@ -1795,6 +1795,24 @@ asmlinkage long compat_sys_select(int n,
> >  	return ret;
> >  }
> >
> > +struct compat_sel_arg_struct {
> > +	compat_ulong_t n;
> > +	compat_ulong_t inp;
> > +	compat_ulong_t outp;
> > +	compat_ulong_t exp;
> > +	compat_ulong_t tvp;
> > +};
>
> Shouldn't the last four be compat_uptr_t?

Strictly speaking yes, although it doesn't matter for the generated
code.  The patch below makes it use the strictly correct type:

Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/compat.c~add-generic-sys_old_select-fix fs/compat.c
--- a/fs/compat.c~add-generic-sys_old_select-fix
+++ a/fs/compat.c
@@ -1796,10 +1796,10 @@ asmlinkage long compat_sys_select(int n,
 
 struct compat_sel_arg_struct {
 	compat_ulong_t n;
-	compat_ulong_t inp;
-	compat_ulong_t outp;
-	compat_ulong_t exp;
-	compat_ulong_t tvp;
+	compat_uptr_t inp;
+	compat_uptr_t outp;
+	compat_uptr_t exp;
+	compat_uptr_t tvp;
 };
 
 asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg)
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
add-generic-sys_old_select.patch
add-generic-sys_old_select-fix.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
ptrace-use-ptrace_request-in-the-remaining-architectures.patch

