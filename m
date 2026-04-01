Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16DB18A92F;
	Wed,  1 Apr 2026 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014801; cv=none; b=EhEEFzRG9LP9Eay04jDQm40AUGU++/WDu8HBSjBUILn46/rnWEF1OucMfGGFyzK/dVc9FYMNmO5z1daP8i+BGZ0qWTFhiXGcTX087jgUD1LVVQSrPoor9gVFIqZMcB0qDpaOy7FQt3kuRU4H+vYUC4Q7RWPhUNDDIOLonECBeiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014801; c=relaxed/simple;
	bh=ZWcIicOOdvfn+OMfQYQPFSYJXZtiMM/Afbew7/SvMJY=;
	h=Date:To:From:Subject:Message-Id; b=hy7pE/Y22+Ybk5V7ssjRo6GUAODzcFOWbVziMbUUNxM9rvhTMe0/XdLmmu31krRHQuyG8UBVhHy7DkF5x+CuyPGryUt7wT7toG2GxuHTBYOgIOFLkNJAU/43tQX4Qrzgit84xgTs8I2HDTewVCfDLru727SGc+zpsFEraMABtOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNxIIXLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNxIIXLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BE6C4CEF7;
	Wed,  1 Apr 2026 03:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775014800;
	bh=ZWcIicOOdvfn+OMfQYQPFSYJXZtiMM/Afbew7/SvMJY=;
	h=Date:To:From:Subject:From;
	b=LNxIIXLUDqziV1rYVRPhVl70KPyoxXiURMvcyGAbhb+f+qiF26tyEXA/hSc+qI/YT
	 3sdQQd+6lcnuIo61/JmhUgWSkqSpaajqVwOtWp3EdpjteS7tJAk5Lztr3SQUgj1BHG
	 QakeQCPwmMu30jtH4v5lpF2a4v9TdQFFCC/U5EIQ=
Date: Tue, 31 Mar 2026 20:39:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store.patch removed from -mm tree
Message-Id: <20260401034000.67BE6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
Date: Tue, 31 Mar 2026 18:07:40 +0800

Add the missing kfree(new_wi_state) when the auto mode is already set to
the requested value.  When a user writes "false" to the auto sysfs
interface and the current mode is already manual (mode_auto == false), the
function returns early without freeing new_wi_state allocated at the
beginning of the function.  This can be triggered repeatedly from
userspace, leaking memory on each write.

Link: https://lkml.kernel.org/r/20260331100740.84906-1-liu.yun@linux.dev
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store
+++ a/mm/mempolicy.c
@@ -3707,6 +3707,7 @@ static ssize_t weighted_interleave_auto_
 			goto update_wi_state;
 		if (input == old_wi_state->mode_auto) {
 			mutex_unlock(&wi_state_lock);
+			kfree(new_wi_state);
 			return count;
 		}
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are

mm-damon-stat-fix-memory-leak-on-damon_start-failure-in-damon_stat_start.patch
mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store.patch

