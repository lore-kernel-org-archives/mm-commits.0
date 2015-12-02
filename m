From: akpm@linux-foundation.org
Subject: + drivers-memory-clean-up-section-counting.patch added to -mm
 tree
Date: Wed, 02 Dec 2015 14:46:23 -0800
Message-ID: <565f74bf.EeD+igmSYON2uSkP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbbLBWqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:46:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjennings@variantweb.net, abanman@sgi.com, daniel@numascale.com, greg@kroah.com, rja@sgi.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory.c: clean up section counting
has been added to the -mm tree.  Its filename is
     drivers-memory-clean-up-section-counting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memory-clean-up-section-counting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memory-clean-up-section-counting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Seth Jennings <sjennings@variantweb.net>
Subject: drivers/base/memory.c: clean up section counting

Right now, section_count is calculated in add_memory_block().  However,
init_memory_block() increments section_count as well, which, at first,
seems like it would lead to an off-by-one error.  There is no harm done
because add_memory_block() immediately overwrites the mem->section_count,
but it is messy.

This commit moves the increment out of the common init_memory_block()
(called by both add_memory_block() and register_new_memory()) and adds it
to register_new_memory().

Signed-off-by: Seth Jennings <sjennings@variantweb.net>
Cc: Andrew Banman <abanman@sgi.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Russ Anderson <rja@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~drivers-memory-clean-up-section-counting drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-memory-clean-up-section-counting
+++ a/drivers/base/memory.c
@@ -618,7 +618,6 @@ static int init_memory_block(struct memo
 			base_memory_block_id(scn_nr) * sections_per_block;
 	mem->end_section_nr = mem->start_section_nr + sections_per_block - 1;
 	mem->state = state;
-	mem->section_count++;
 	start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
 
@@ -672,6 +671,7 @@ int register_new_memory(int nid, struct
 		ret = init_memory_block(&mem, section, MEM_OFFLINE);
 		if (ret)
 			goto out;
+		mem->section_count++;
 	}
 
 	if (mem->section_count == sections_per_block)
_

Patches currently in -mm which might be from sjennings@variantweb.net are

drivers-memory-prohibit-offlining-of-memory-blocks-with-missing-sections.patch
drivers-memory-clean-up-section-counting.patch
drivers-memory-rename-remove_memory_block-to-remove_memory_section.patch

