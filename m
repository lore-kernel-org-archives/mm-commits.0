Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEBE22D7A1
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 20:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758227901; cv=none; b=rzQ5xAm8qSIARQjn62X+/ssQ7ccLoEDau58zMc7yoNE+290UEl5u9xPsDPaCLtEDaMuZLL4UBbGCyyc59jkCXo7UEo5VZ4zDZpsXkHDF08rcASoiXgwHRJuyxavOinCf6bHnoJQOSKFA+s2GpZoJbfuwJtTGo8pq/3ZJ4mg4xjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758227901; c=relaxed/simple;
	bh=0Q2XwKszm2AK2Q7+ZwNxGZeK/IcCaCwqpMYnAmjyl9A=;
	h=Date:To:From:Subject:Message-Id; b=IRFtMIGZN6JRm8vOI86YDVC/9acaNegYkcBWUxk/T07BNFVFyu9jdW62pRoYzTBQuo7aKOORhaEX119SESdc8UCuqNxftRpY/ih5aOryWHTxpKcUDrAR2HveUpMbzMdPmVkDQCQSIdZzmdQ7Hysrsr3zYTlipU9LLWJrTjA8hAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WxwYDQXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WxwYDQXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9144C4CEE7;
	Thu, 18 Sep 2025 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758227900;
	bh=0Q2XwKszm2AK2Q7+ZwNxGZeK/IcCaCwqpMYnAmjyl9A=;
	h=Date:To:From:Subject:From;
	b=WxwYDQXCsGj0u7w9oPFOjrnB6nepjpb5jqZaXOUx3NkoR41yA4RMvY9M/OPvf4OyX
	 V95bXYAvufovFB/8dT2YQlCxQBTZAd7QQE3+ialcu9zpCdVSDm7g2PaZfGtD/tooJj
	 AwHwZi4XzzkywL1fq2HNhUTTi7fjWoY9CaaHJ3hQ=
Date: Thu, 18 Sep 2025 13:38:19 -0700
To: mm-commits@vger.kernel.org,manish1588@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-update-printk-pr_info-messages-and-replace-legacy-printkkern_cont-with-pr_cont.patch added to mm-new branch
Message-Id: <20250918203819.E9144C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/show_mem: update printk/pr_info messages and replace legacy printk(KERN_CONT ...) with pr_cont()
has been added to the -mm mm-new branch.  Its filename is
     mm-show_mem-update-printk-pr_info-messages-and-replace-legacy-printkkern_cont-with-pr_cont.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-update-printk-pr_info-messages-and-replace-legacy-printkkern_cont-with-pr_cont.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Manish Kumar <manish1588@gmail.com>
Subject: mm/show_mem: update printk/pr_info messages and replace legacy printk(KERN_CONT ...) with pr_cont()
Date: Thu, 18 Sep 2025 23:44:03 +0530

Link: https://lkml.kernel.org/r/20250918181403.93812-1-manish1588@gmail.com
Signed-off-by: Manish Kumar <manish1588@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/show_mem.c~mm-show_mem-update-printk-pr_info-messages-and-replace-legacy-printkkern_cont-with-pr_cont
+++ a/mm/show_mem.c
@@ -26,7 +26,7 @@ unsigned long totalcma_pages __read_most
 static inline void show_node(struct zone *zone)
 {
 	if (IS_ENABLED(CONFIG_NUMA))
-		printk("Node %d ", zone_to_nid(zone));
+		pr_info("Node %d ", zone_to_nid(zone));
 }
 
 long si_mem_available(void)
@@ -156,7 +156,7 @@ static void show_migration_types(unsigne
 	}
 
 	*p = '\0';
-	printk(KERN_CONT "(%s) ", tmp);
+	pr_cont("(%s) ", tmp);
 }
 
 static bool node_has_managed_zones(pg_data_t *pgdat, int max_zone_idx)
_

Patches currently in -mm which might be from manish1588@gmail.com are

mm-show_mem-update-printk-pr_info-messages-and-replace-legacy-printkkern_cont-with-pr_cont.patch

