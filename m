Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13F64C
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560113; cv=none; b=EoKTDS5JVD90YcQn+aYbkNPHer0nnE5yfo6r8C2fBHIFzjMDMHeRnh/QmMK/XNghGsx/aG0T3rjDbduhMtqvj3O8FRR49pnsYkonPfvROZG3NDov4lpf4RBRB6PqJkUu/k4e7RnJ78rKor05WfaU3YtXCPfVoZkuwn8lG+GCQTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560113; c=relaxed/simple;
	bh=zEJqxxRJzqr/nCrcCCuVhIcpR48dKZQ7yj8C2CaPFfE=;
	h=Date:To:From:Subject:Message-Id; b=jsxYNTHPrfsmjZnXrkZtmepRO0j8dmkkyWHyxPhx5VxDrFyMFxt8n33CP/FSfGsM5Ijn11unW088PCVceLIwnLHmQ5FktzVOGG/844zutB1AM2J6S37/RgeDJlWU0S90/yNQLT4a2qFodsZ4nde6CF170yTUVg0zf86wpWO7hC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rIK66Yvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rIK66Yvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D95C433C7;
	Thu, 22 Feb 2024 00:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560113;
	bh=zEJqxxRJzqr/nCrcCCuVhIcpR48dKZQ7yj8C2CaPFfE=;
	h=Date:To:From:Subject:From;
	b=rIK66YvuuVl5oF5WGfhIFk5S+3/LwJiEPz7ZAi+jpgPCWD0cngmnFbWAmJ7yMIIo6
	 hOE31FJlfp6+cyileJDHBfvFalbxGuNYIiv/my4dW3qphYRRcQz36xs0xUT4kR02EP
	 8Pl7e+V6G7HXMUGS+E+gAVwujotakOvC6gTQ38Lo=
Date: Wed, 21 Feb 2024 16:01:52 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch removed from -mm tree
Message-Id: <20240222000152.E4D95C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: rename zswap_free_entry to zswap_entry_free
has been removed from the -mm tree.  Its filename was
     mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: rename zswap_free_entry to zswap_entry_free
Date: Mon, 29 Jan 2024 20:36:37 -0500

There is a zswap_entry_ namespace with multiple functions already.

Link: https://lkml.kernel.org/r/20240130014208.565554-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-rename-zswap_free_entry-to-zswap_entry_free
+++ a/mm/zswap.c
@@ -519,7 +519,7 @@ static struct zpool *zswap_find_zpool(st
  * Carries out the common pattern of freeing and entry's zpool allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
-static void zswap_free_entry(struct zswap_entry *entry)
+static void zswap_entry_free(struct zswap_entry *entry)
 {
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
@@ -554,7 +554,7 @@ static void zswap_entry_put(struct zswap
 	WARN_ON_ONCE(refcount < 0);
 	if (refcount == 0) {
 		WARN_ON_ONCE(!RB_EMPTY_NODE(&entry->rbnode));
-		zswap_free_entry(entry);
+		zswap_entry_free(entry);
 	}
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


