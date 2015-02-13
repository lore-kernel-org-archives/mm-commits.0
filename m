From: akpm@linux-foundation.org
Subject: [merged] arch-frv-mm-extablec-remove-unused-function.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:33 -0800
Message-ID: <54de5ccd.gAtNT46O8KFeUNKf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/frv/mm/extable.c:  remove unused function
has been removed from the -mm tree.  Its filename was
     arch-frv-mm-extablec-remove-unused-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: arch/frv/mm/extable.c:  remove unused function

Remove the function search_one_table() that is not used anywhere.

This was partially found by using a static code analysis program called
cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/extable.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN arch/frv/mm/extable.c~arch-frv-mm-extablec-remove-unused-function arch/frv/mm/extable.c
--- a/arch/frv/mm/extable.c~arch-frv-mm-extablec-remove-unused-function
+++ a/arch/frv/mm/extable.c
@@ -10,29 +10,6 @@ extern const void __memset_end, __memset
 extern const void __memcpy_end, __memcpy_user_error_lr, __memcpy_user_error_handler;
 extern spinlock_t modlist_lock;
 
-/*****************************************************************************/
-/*
- *
- */
-static inline unsigned long search_one_table(const struct exception_table_entry *first,
-					     const struct exception_table_entry *last,
-					     unsigned long value)
-{
-        while (first <= last) {
-		const struct exception_table_entry __attribute__((aligned(8))) *mid;
-		long diff;
