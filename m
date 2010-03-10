From: akpm@linux-foundation.org
Subject: [folded] add-generic-sys_old_select-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:49:05 -0800
Message-ID: <201003102249.o2AMn5Ed008455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932801Ab0CJWtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:49:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, schwab@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     add-generic-sys_old_select-fix.txt
has been removed from the -mm tree.  Its filename was
     add-generic-sys_old_select-fix.patch

This patch was dropped because it was folded into add-generic-sys_old_select.patch

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

add-generic-sys_old_select.patch
add-generic-sys_old_select-fix.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
ptrace-use-ptrace_request-in-the-remaining-architectures.patch
ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch
alpha-use-generic-ptrace_resume-code.patch
arm-use-generic-ptrace_resume-code.patch
avr32-use-generic-ptrace_resume-code.patch
h8300-use-generic-ptrace_resume-code.patch
m68knommu-use-generic-ptrace_resume-code.patch
microblaze-use-generic-ptrace_resume-code.patch
mips-use-generic-ptrace_resume-code.patch
um-use-generic-ptrace_resume-code.patch
xtensa-use-generic-ptrace_resume-code.patch
cris-arch-v10-use-generic-ptrace_resume-code.patch
cris-arch-v32-use-generic-ptrace_resume-code.patch
m32r-use-generic-ptrace_resume-code.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch

