From: akpm@linux-foundation.org
Subject: [merged]
 kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:46:07 -0700
Message-ID: <523219ff.1y9VoiXcdsnyaANJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ILTqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, dhowells@redhat.com, ak@linux.intel.com

Subject: [merged] kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch removed from -mm tree
To: ak@linux.intel.com,dhowells@redhat.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:46:07 -0700


The patch titled
     Subject: kernel/modsign_pubkey.c: fix init const for module signing code
has been removed from the -mm tree.  Its filename was
     kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: kernel/modsign_pubkey.c: fix init const for module signing code

const has to use __initconst, not __initdata

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/modsign_pubkey.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/modsign_pubkey.c~kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code kernel/modsign_pubkey.c
--- a/kernel/modsign_pubkey.c~kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code
+++ a/kernel/modsign_pubkey.c
@@ -18,14 +18,14 @@
 
 struct key *modsign_keyring;
 
-extern __initdata const u8 modsign_certificate_list[];
-extern __initdata const u8 modsign_certificate_list_end[];
+extern __initconst const u8 modsign_certificate_list[];
+extern __initconst const u8 modsign_certificate_list_end[];
 
 /*
  * We need to make sure ccache doesn't cache the .o file as it doesn't notice
  * if modsign.pub changes.
  */
-static __initdata const char annoy_ccache[] = __TIME__ "foo";
+static __initconst const char annoy_ccache[] = __TIME__ "foo";
 
 /*
  * Load the compiled-in keys
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

