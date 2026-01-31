Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB8420CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898256; cv=none; b=hoCUY2/3iAt9GEncuLcy5mUQDqdQ4RiiM+D5vzi4WZLV7aHSMXwh2YYzGq0FXjiAQWsWXG/prdEKPz6N7G6S+h6j2MSuXOFkAtIbH9VExBfCVkztqZGtdstsnDzlGCcePhascAiDtqfF3q8ECSufikzfjkyKO6RKTgNxJTh+w/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898256; c=relaxed/simple;
	bh=SN5xuG/8AQSs9AUraX17QsczlY7kqukDphe3kcP+8xI=;
	h=Date:To:From:Subject:Message-Id; b=WVTCAxp+RL8KkVYyMuN0y6BHPyiU/RCWfdNUbZv0YmR80YiqV6/B6EPecLMihTpHN4E26/OhbQTJMaesKTnOgbr407BPGRpVRZwMAypLezU1eCpqLeiEZHyQNc1veUioF69H6K36cQ74YNJTCLeDuN+oysChI2tmXcVP30QU2/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mN7/THR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mN7/THR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02858C4CEF1;
	Sat, 31 Jan 2026 22:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898256;
	bh=SN5xuG/8AQSs9AUraX17QsczlY7kqukDphe3kcP+8xI=;
	h=Date:To:From:Subject:From;
	b=mN7/THR4++gaxcL5sQ95Sjv067yA+nRnVvm1PzG3Qz/kdtLxatFzaUiT8IGNBmBOG
	 z3jWX4a0jKJQd0IaJ4KTIOohhBCm5GYH4rtZW6rJ40Gv97K9Ywhul18HphXAyRZXlo
	 MC21APMT9yNRKr+x6jL2TSBKPMs+VGvjzpQ6cqOc=
Date: Sat, 31 Jan 2026 14:24:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-make-balloon_mops-static.patch removed from -mm tree
Message-Id: <20260131222416.02858C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: make balloon_mops static
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-make-balloon_mops-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/balloon_compaction: make balloon_mops static
Date: Tue, 20 Jan 2026 00:01:18 +0100

There is no need to expose this anymore, so let's just make it static.

Link: https://lkml.kernel.org/r/20260119230133.3551867-11-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    1 -
 mm/balloon_compaction.c            |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-make-balloon_mops-static
+++ a/include/linux/balloon_compaction.h
@@ -78,7 +78,6 @@ static inline void balloon_devinfo_init(
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
-extern const struct movable_operations balloon_mops;
 /*
  * balloon_page_device - get the b_dev_info descriptor for the balloon device
  *			 that enqueues the given page.
--- a/mm/balloon_compaction.c~mm-balloon_compaction-make-balloon_mops-static
+++ a/mm/balloon_compaction.c
@@ -288,7 +288,7 @@ static int balloon_page_migrate(struct p
 	return 0;
 }
 
-const struct movable_operations balloon_mops = {
+static const struct movable_operations balloon_mops = {
 	.migrate_page = balloon_page_migrate,
 	.isolate_page = balloon_page_isolate,
 	.putback_page = balloon_page_putback,
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

