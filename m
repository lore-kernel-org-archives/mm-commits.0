Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4892D2391
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308796; cv=none; b=Z24N8vB2/MUr45m9X/PI62oGpI40h8zV3ckOmDR7u4oBWmIoA7fAFU5Zb27CtSawsgqOl8olin2oM6PoYcd1v9umg8Q2G795l7Q2NM7Y7coLp86XLYYFU+SSFb6BpF3f8J1ZwzKjyVWt0MoXQCDavuUT7CL2DpY56TaREL1z+IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308796; c=relaxed/simple;
	bh=Lf4DbE3eUmsm5032FYLMRjbkM0l8joKCcJx5BgDU2Sg=;
	h=Date:To:From:Subject:Message-Id; b=hLQvdUIOvzsZJlCY2A0HjHhr04qQIqi0xytXhPi3WHWWe6kgcdAI/P8UPq9Oua858asovPxVlhQ6gIUt+6i1Oecr+fQOk7FbbwQ4NF2uDE9NNpFysopHEhJRq9CoBpkVdq2emJQ29WjhL3cMlPwnEz7vPYTFAAEIpNY4zLzp4pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZyDasOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZyDasOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD318C4CEF5;
	Tue,  9 Dec 2025 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308795;
	bh=Lf4DbE3eUmsm5032FYLMRjbkM0l8joKCcJx5BgDU2Sg=;
	h=Date:To:From:Subject:From;
	b=ZZyDasOV6EZytdB3y3NmGCzaeL35XxYGOl4+gkUdavgkx2ZHZr89vKT19mOkEL1R9
	 kqb0n5gsfGFfA2TvXfjNkSkygKIjnsl3wDpAPXOWhEblWQPG7P4bw2mmLCMWxzKLSN
	 J4foSF/+GXFfWGQbvcjCqhZU7bwASEnwiRL5UClE=
Date: Tue, 09 Dec 2025 11:33:15 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,lkp@intel.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] liveupdate-luo_file-dont-use-invalid-list-iterator.patch removed from -mm tree
Message-Id: <20251209193315.AD318C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: luo_file: don't use invalid list iterator
has been removed from the -mm tree.  Its filename was
     liveupdate-luo_file-dont-use-invalid-list-iterator.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: liveupdate: luo_file: don't use invalid list iterator
Date: Fri, 28 Nov 2025 10:17:07 +0300

If we exit a list_for_each_entry() without hitting a break then the list
iterator points to an offset from the list_head.  It's a non-NULL but
invalid pointer and dereferencing it isn't allowed.

Introduce a new "found" variable to test instead.

Link: https://lkml.kernel.org/r/aSlMc4SS09Re4_xn@stanley.mountain
Fixes: 3ee1d673194e ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202511280420.y9O4fyhX-lkp@intel.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-dont-use-invalid-list-iterator
+++ a/kernel/liveupdate/luo_file.c
@@ -561,17 +561,20 @@ int luo_retrieve_file(struct luo_file_se
 {
 	struct liveupdate_file_op_args args = {0};
 	struct luo_file *luo_file;
+	bool found = false;
 	int err;
 
 	if (list_empty(&file_set->files_list))
 		return -ENOENT;
 
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
-		if (luo_file->token == token)
+		if (luo_file->token == token) {
+			found = true;
 			break;
+		}
 	}
 
-	if (luo_file->token != token)
+	if (!found)
 		return -ENOENT;
 
 	guard(mutex)(&luo_file->mutex);
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


