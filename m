From: akpm@linux-foundation.org
Subject: [merged] checksyscalls-fix-here-document-handling.patch removed from -mm tree
Date: Wed, 26 Sep 2012 12:35:30 -0700
Message-ID: <20120926193530.A95F51E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45884 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab2IZTfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 15:35:31 -0400
Received: by yenr11 with SMTP id r11so113859yen.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 12:35:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, gorcunov@openvz.org, hpa@linux.intel.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: checksyscalls: fix "here document" handling
has been removed from the -mm tree.  Its filename was
     checksyscalls-fix-here-document-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: checksyscalls: fix "here document" handling

"echo" doesn't read from stdin, therefore the checksyscalls script didn't
warn about not implemented system calls anymore since 29dc54c6
("checksyscalls: Use arch/x86/syscalls/syscall_32.tbl as source").

Use "cat" instead of "echo" which handles this correctly.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checksyscalls.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checksyscalls.sh~checksyscalls-fix-here-document-handling scripts/checksyscalls.sh
--- a/scripts/checksyscalls.sh~checksyscalls-fix-here-document-handling
+++ a/scripts/checksyscalls.sh
@@ -200,7 +200,7 @@ EOF
 syscall_list() {
     grep '^[0-9]' "$1" | sort -n | (
 	while read nr abi name entry ; do
-	    echo <<EOF
+	    cat <<EOF
 #if !defined(__NR_${name}) && !defined(__IGNORE_${name})
 #warning syscall ${name} not implemented
 #endif
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390-fix.patch

