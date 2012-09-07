From: akpm@linux-foundation.org
Subject: + checksyscalls-fix-here-document-handling.patch added to -mm tree
Date: Fri, 07 Sep 2012 14:46:28 -0700
Message-ID: <20120907214629.206BA1000BB@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:44567 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2IGVqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 17:46:30 -0400
Received: by yhl10 with SMTP id 10so8652yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 14:46:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, gorcunov@openvz.org, hpa@linux.intel.com, mmarek@suse.cz


The patch titled
     Subject: checksyscalls: fix "here document" handling
has been added to the -mm tree.  Its filename is
     checksyscalls-fix-here-document-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: checksyscalls: fix "here document" handling

"echo" doesn't read from stdin, therefore the checksyscalls script didn't
warn about not implemented system calls anymore since 29dc54c6
"checksyscalls: Use arch/x86/syscalls/syscall_32.tbl as source".

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

linux-next.patch
checksyscalls-fix-here-document-handling.patch
checksyscalls-ignore-kcmp-system-call.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

