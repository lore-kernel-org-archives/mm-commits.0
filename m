Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04603B42F0
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068035; cv=none; b=lnAocmiyqifduQeC+18JQxm2ogBgc6pkyzr6XYfMCEEujt8cxe7zhS5q1P1HeKNqLzR1Mawm+hsMjqEbLuZmzM4CjwC5SBoQYTTAHwO7h8c5zIgY4bXmpciIgF/qKkKjfsQUStKATO5NmuraYoIsfAHbGW8qIoCLiq8TOy1MX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068035; c=relaxed/simple;
	bh=45VX+KhJxX1s6NoI7w9n00K49uiC2Rx2tBg1fiigyx0=;
	h=Date:To:From:Subject:Message-Id; b=TgvNHklRfoXZY/ICI2u6SeFVbp7j0DG3/ucjUktiLHH3nkRn1VCKiNPx2clL/Tj12Jup7/A7XCEJi4a57xXYjTQF99ioVQ2EQC7G7518eMDcDlK3IpmUjMMJglI7LriqTNBkrYiu5yJoSvQrHAtOuIx9sOPfiC+ghIDK/vQDgss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LSqmVLY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LSqmVLY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196631F00ADE;
	Fri,  7 Aug 2026 02:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068026;
	bh=m1lcWaAd7YG3nuUumyjHn6NqGSGplP7S8nsHm+iP6nM=;
	h=Date:To:From:Subject;
	b=LSqmVLY4VJgI8viaW8kARqlnGNh2Q/vQAgkSyb+gT69Zm8mw/jO3RJZ9aoV6blcX0
	 47deQOCx0X3CtilsTZYD4LmhGMCuJCV5HHavtPiH05OnMsTPpEDpL0boTXpzZoJPkP
	 7YyTx79XwlhLk1kfAljXXVnuKrIVUOeI8doUMtIQ=
Date: Thu, 06 Aug 2026 19:00:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-update_tuned_intervals-state-command.patch removed from -mm tree
Message-Id: <20260807020026.196631F00ADE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document update_tuned_intervals state command
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-update_tuned_intervals-state-command.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: Docs/ABI/damon: document update_tuned_intervals state command
Date: Tue, 14 Jul 2026 07:01:15 -0700

The 'update_tuned_intervals' command of the 'state' file, added in commit
1077605396b4 ("mm/damon/sysfs: implement a command to update auto-tuned
monitoring intervals"), is described in usage.rst but missing from the
canonical ABI document.  Add it.

Link: https://lore.kernel.org/20260714140117.94147-4-sj@kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-update_tuned_intervals-state-command
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -36,7 +36,10 @@ Description:	Writing 'on' or 'off' to th
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
 		removes contents of the 'tried_regions' directory.  Writing
 		'update_schemes_effective_quotas' to the file updates
-		'.../quotas/effective_bytes' files of this kdamond.
+		'.../quotas/effective_bytes' files of this kdamond.  Writing
+		'update_tuned_intervals' to the file updates 'sample_us' and
+		'aggr_us' files under 'monitoring_attrs/intervals' with the
+		auto-tuned sampling and aggregation intervals.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
_

Patches currently in -mm which might be from husong@kylinos.cn are


