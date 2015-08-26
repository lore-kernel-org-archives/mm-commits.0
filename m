From: akpm@linux-foundation.org
Subject: +
 mm-check-if-section-present-during-memory-block-registering-fix-2.patch
 added to -mm tree
Date: Wed, 26 Aug 2015 15:17:42 -0700
Message-ID: <55de3b06.01xH721icQvIjTbb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbbHZWRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 18:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, greg@kroah.com, mingo@elte.hu, tony.luck@intel.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-check-if-section-present-during-memory-block-registering-fix-2
has been added to the -mm tree.  Its filename is
     mm-check-if-section-present-during-memory-block-registering-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-check-if-section-present-during-memory-block-registering-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-check-if-section-present-during-memory-block-registering-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm-check-if-section-present-during-memory-block-registering-fix-2

more simplification

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-check-if-section-present-during-memory-block-registering-fix-2 drivers/base/node.c
--- a/drivers/base/node.c~mm-check-if-section-present-during-memory-block-registering-fix-2
+++ a/drivers/base/node.c
@@ -396,7 +396,7 @@ int register_mem_sect_under_node(struct
 		 * memory block could have several absent sections from start.
 		 * skip pfn range from absent section
 		 */
-		if (!present_section_nr(pfn_to_section_nr(pfn))) {
+		if (!pfn_present(pfn)) {
 			pfn = round_down(pfn + PAGES_PER_SECTION,
 					 PAGES_PER_SECTION) - 1;
 			continue;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-check-if-section-present-during-memory-block-registering-fix-2.patch
mm-improve-__gfp_noretry-comment-based-on-implementation.patch
mm-oom-organize-oom-context-into-struct.patch
mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch
mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch
mm-oom-add-description-of-struct-oom_control.patch
mm-oom-remove-unnecessary-variable.patch

