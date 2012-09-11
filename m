From: akpm@linux-foundation.org
Subject: + compat_ioctl-remove-unused-local-typedef.patch added to -mm tree
Date: Tue, 11 Sep 2012 16:15:17 -0700
Message-ID: <20120911231517.95B0A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45430 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab2IKXPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 19:15:18 -0400
Received: by yenq6 with SMTP id q6so123383yen.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 16:15:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, arnd@arndb.de


The patch titled
     Subject: compat_ioctl: Remove unused local typedef
has been added to the -mm tree.  Its filename is
     compat_ioctl-remove-unused-local-typedef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: compat_ioctl: Remove unused local typedef

gcc 4.8 always warns

fs/compat_ioctl.c: In function 'serial_struct_ioctl':
fs/compat_ioctl.c:609:38: warning: typedef 'SS' locally defined but not used [-Wunused-local-typedefs]
         typedef struct serial_struct SS;

Indeed that typedef is unused, so just remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/compat_ioctl.c~compat_ioctl-remove-unused-local-typedef fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-remove-unused-local-typedef
+++ a/fs/compat_ioctl.c
@@ -606,7 +606,6 @@ struct serial_struct32 {
 static int serial_struct_ioctl(unsigned fd, unsigned cmd,
 			struct serial_struct32 __user *ss32)
 {
-        typedef struct serial_struct SS;
         typedef struct serial_struct32 SS32;
         int err;
         struct serial_struct ss;
_

Patches currently in -mm which might be from ak@linux.intel.com are

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
compat_ioctl-remove-unused-local-typedef.patch

