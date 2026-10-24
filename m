Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832323;
	b=H3XKsemgcBwp6yopUZKOlQ5pXCMhoKNwZ5IO+vYrLeemwnruAtRZWtbuwgZX9j3jH51X
	 CzZRrri/Me5iI++WuzbBJwdiPXGuzRSzoSPQY9B4kdmcLbxn0DmVhu1nkqHBhppRjQ4Pu
	 QJtAZMY/XPj/HCWiDES6qGxr/CQ0C5RQW9mbRxvc6KSrYKSuBL3ZTwP+AQwu/9R2ifbhC
	 kkQFHsAlF3dxEbHP8c0Sb4mTn4TR0S9HIDKANVynZGTUSdur8O2cwrs98L3NyDGAlD9Gn
	 uKtrpnt+FVWcpYYULVz3ehJU2+hdoR7Efk+BPmAkNmKX5m29jTfonmJ/1/K5DU9BvzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832323;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JuFKbMClbZdiQgFchkwDHgcHPQgvWa2WMR7FX4pnzEE=;
	b=o2CYdDiz1N4+8nW0aA1jfR70btodGucbkBTUieqzkdtAKI08g4G20QM7nK6fbzAgC6lj
	 qee3VQBNzn+F8LXdbyyqwuMv2VcbsTUCCaXoxtDZkIq9ltt9KeVpvIumciKTQdbZ5dnj8
	 lFu1SjWyzbW6qH21ykaotAA4+zvvX3A3X+P9IbPTFiWo9HYKcnre29kfqHO2nK7hvEI2m
	 3zMcE1sL6XXMRLuMzC8ZS6oX8VqfMlW/kdSdPgsAkGaCE0oojWe0etLBVsqGooPqpxtfN
	 z81gKNfrLxSesIQCWN7luLszC8s+uQuB3/zBcpcgmeHL8vGCE6A0iw7/OM5p1YurjmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CuhXvq7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B8606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CuhXvq7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11BD1F01828;
	Sat, 24 Oct 2026 08:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832322;
	bh=JuFKbMClbZdiQgFchkwDHgcHPQgvWa2WMR7FX4pnzEE=;
	h=Date:To:From:Subject;
	b=CuhXvq7wSJ9a9QA0YtFDW5MIy1VAJAZzqAznAkWmWZzkfWzsfdVkHCyQZ5YKBDUEu
	 IWh46Tvb/uGVJof5h2jH0niABrPiKFdbYDrIKNBbiKlERBp9mt3iIhTUitSuRArioT
	 NKI0XnLbAPUTb4UturxArSsxrdMwsUE1fVibnkeg=
Date: Sat, 24 Oct 2026 01:58:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch removed from -mm tree
Message-Id: <20261024085842.B11BD1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Docs/ABI/damon: update for quota goal metric complement sysfs file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for quota goal metric complement sysfs file
Date: Tue, 29 Sep 2026 01:01:11 -0700

Update DAMON ABI document for the newly added damos quota goal metric
complement sysfs file.

Link: https://lore.kernel.org/20260929080113.41708-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -375,6 +375,12 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/complement
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets whether to
+		use the complement value of the quota auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SJ Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are


