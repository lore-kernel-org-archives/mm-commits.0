Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FEE23ABA7
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343269; cv=none; b=fxTEifafHX8fIoCX1cxkVKpEi5Nc6V/T/QyEYNxnLkhBnBG6IyBKVNnnsem5cC1Clio41G6ZfemvRdHZP5C8hB/40yjx5s+fd8v60bJbr/4v5mgTyyy1L/WCTeQadXpZj2gN4KLW4W+2NShcZtwtxQ+TNUhG8MkFgZ+mbV4gfz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343269; c=relaxed/simple;
	bh=4CyfAiInsTiEQcVRRNEVDTgNacUxbHERKwgP0OhvcxI=;
	h=Date:To:From:Subject:Message-Id; b=JsNYnoYqVy0KmephszUQFcOLMjjtQ6+H5+hhI9uyFhIQT1wypnoOQnygD7kluuOqvPFzgvQbe3bKeQSO3BOItmFarsQEUbSVhluchefOrqA4MiFjS2Suv4rzJ0a98rlemHzRtvYMqd6mA0PIQ4DShgVP2qAxjTt0Wlg6pTTc2D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GoTh/Nn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GoTh/Nn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5E9C4CEF1;
	Mon, 17 Nov 2025 01:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343269;
	bh=4CyfAiInsTiEQcVRRNEVDTgNacUxbHERKwgP0OhvcxI=;
	h=Date:To:From:Subject:From;
	b=GoTh/Nn2tsqgtxfk9nMHboAaKyTZsNxS7um44TojvOsPIxOfyhM1itZLOkp839BpB
	 IOVLfZjt4KUAj1vQsMuRADJFtNrmgggqrBjtK/uMvxFGkkJMhi/29v0aMTqeTx4RHC
	 LaRQyQUsgRxlQsDLsjjUm0IRSHiRjTvce9G2vubg=
Date: Sun, 16 Nov 2025 17:34:28 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo.patch removed from -mm tree
Message-Id: <20251117013429.3A5E9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmstat: output reserved_highatomic and free_highatomic in zoneinfo
has been removed from the -mm tree.  Its filename was
     mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm: vmstat: output reserved_highatomic and free_highatomic in zoneinfo
Date: Mon, 27 Oct 2025 22:18:17 +0800

The nr_free_highatomic is a key factor in calculating watermarks as it
affects the free pages count.  Adding this metric, along with
nr_reserved_highatomic, to /proc/zoneinfo facilitates easier diagnosis
memory watermark calculations and memory pressure states.

Sample output:
cat /proc/zoneinfo
......
pagesets
cpu: 0
		  count:    52069
		  high:     52675
		  batch:    63
		  high_min: 13971
		  high_max: 62284
vm stats threshold: 10
node_unreclaimable:  0
start_pfn:           4096
reserved_highatomic: 5120
free_highatomic:     2081

Link: https://lkml.kernel.org/r/20251027141818.283587-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo
+++ a/mm/vmstat.c
@@ -1852,9 +1852,13 @@ static void zoneinfo_show_print(struct s
 	}
 	seq_printf(m,
 		   "\n  node_unreclaimable:  %u"
-		   "\n  start_pfn:           %lu",
+		   "\n  start_pfn:           %lu"
+		   "\n  reserved_highatomic: %lu"
+		   "\n  free_highatomic:     %lu",
 		   atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES,
-		   zone->zone_start_pfn);
+		   zone->zone_start_pfn,
+		   zone->nr_reserved_highatomic,
+		   zone->nr_free_highatomic);
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch

