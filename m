Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AC93C2774
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439183; cv=none; b=rN4bz6x2JHQHnTVVVdQNc2Qfi+UnHT9uUQlkrWi4ktifb8Oh7uf+npWYo83mWFgY/HOb8ujYhqhqncyStfsvO3mqu9T0mwduB7asSoivZdrp1mMK1sicKW5VMbNg6cuEd5Hbg6bLTDalLLzekIlT+XXcHaa8iOA8khAQY5CKenk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439183; c=relaxed/simple;
	bh=gA2MQyzqQaZZZk/kRq8qW+0WMCoYeTdMMa9PJ8vb8dk=;
	h=Date:To:From:Subject:Message-Id; b=DXKLijk7bo7NIpGQODXCrAriiQkzggTq9E0JZ49ViHNr5N5i1Z+utAENYFgZepa7n3FkXPeitOftXFMakW1rZg1J7oTaYW/x11JOMpdfD5kSlJKnhVYnX25Klti0Hjs5zwtonAmCgiOYk4YWin1Y0BMcjjsiDHobVfoON58WAjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z8F5xsTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z8F5xsTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028531F00893;
	Tue,  2 Jun 2026 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439182;
	bh=/yRM+fzL5Rkgn9aU7C9I0Nu5zJNXNxyszLHL36rwaGE=;
	h=Date:To:From:Subject;
	b=z8F5xsTytZ34WT1qQJTub9A3yHK+rZSAJKNtNagDOYelfqQ8KcVIfuqnkOaSlVbrS
	 fCzLO3Sk5V5MUQu+gixmDwZzNGray6xEzUUStNEv9mgAmoF8gCCCkBOPouQmQ/1BPh
	 D1uvkujQO/rYyGk7QENdQ29105hfKlFuvXgGSBBU=
Date: Tue, 02 Jun 2026 15:26:21 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kasong@tencent.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch removed from -mm tree
Message-Id: <20260602222622.028531F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: avoid reclaim type fall back when isolation makes no progress
has been removed from the -mm tree.  Its filename was
     mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: avoid reclaim type fall back when isolation makes no progress
Date: Tue, 28 Apr 2026 02:06:57 +0800

While isolation makes no progress in scan_folios(), we quickly fall back
to the other type in isolate_folios().  This is incorrect, as the current
type may still have sufficient folios.  Falling back can undermine the
positive_ctrl_err() result from get_type_to_scan(), which is derived from
swappiness.

So just continue scanning this type for another round.

Worth noting if the cold generations are all reclaimed, scan will no
longer make any progress either, which may undermine the swappiness again.
This is not a new issue and hence better be fixed later [1].

Link: https://lore.kernel.org/linux-mm/CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com/ [1]
Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-6-02fabb92dc43@tencent.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress
+++ a/mm/vmscan.c
@@ -4821,8 +4821,13 @@ static int isolate_folios(unsigned long
 			*isolate_scanned = scanned;
 			break;
 		}
-
-		type = !type;
+		/*
+		 * If scanned > 0 and isolated == 0, avoid falling back to the
+		 * other type, as this type remains sufficient. Falling back
+		 * too readily can disrupt the positive_ctrl_err() bias.
+		 */
+		if (!scanned)
+			type = !type;
 	}
 
 	return total_scanned;
_

Patches currently in -mm which might be from baohua@kernel.org are


