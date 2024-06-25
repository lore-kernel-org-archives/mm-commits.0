Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646BD1428FA
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291618; cv=none; b=SMgDk/QOfwF3a/rb0v9WTACavjJe39ZMdgpyzxh0hojUDuAD+P8JzgBeNoV5FUV4eKUEoUVJ9/p9tgS+sgGFNbJrERYkrcqt3WRPPX9kk6e1L6E4eeQ94J7fGpvlFr9i17NrDfHcWOyNJWz/1ZcIp9N+bQBp4gG56XUTXxXSbA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291618; c=relaxed/simple;
	bh=or/bj+s/MAWqvSXVM3cGcByWP2JCFUiOZkvuqubM9Wk=;
	h=Date:To:From:Subject:Message-Id; b=buf71AOzxCFt1vn6MeXrKXbuE4XyAWjpLk6foG36E1CHjo7tW2WITXbpdKd5ZW9gJxTAF+/F2EyaBVIbpb5WlL2DYjBvNaKbsCKI6fD7HfDGR+38KaAlH4pGVyZ2iIbkVMeCAT9CFH3O668UAV9eW+hNQ2tpiAX1EhKC0Q6WV8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fGqix03a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fGqix03a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E835FC32782;
	Tue, 25 Jun 2024 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291618;
	bh=or/bj+s/MAWqvSXVM3cGcByWP2JCFUiOZkvuqubM9Wk=;
	h=Date:To:From:Subject:From;
	b=fGqix03ahCvFxeh89fU8QCHdgSjVoD87NcgMNll/PdMKwhsO4pMmDHapsoh61Mrc0
	 iEvt1NQ1eQC5DQRNemTkqcOw1HC2b6y87ZSppGy31lf0hjSaEBtTzHD1blQRZbyWO/
	 ng95k8kkTWYvYRrxJ87K6KRZa6TdlrWujPIQHP08=
Date: Mon, 24 Jun 2024 22:00:17 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,tj@kernel.org,lstoakes@gmail.com,hch@infradead.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-add-__this_cpu_try_cmpxchg.patch removed from -mm tree
Message-Id: <20240625050017.E835FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: add __this_cpu_try_cmpxchg()
has been removed from the -mm tree.  Its filename was
     percpu-add-__this_cpu_try_cmpxchg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: add __this_cpu_try_cmpxchg()
Date: Tue, 28 May 2024 16:43:13 +0200

Add __this_cpu_try_cmpxchg() version of the percpu op.

Link: https://lkml.kernel.org/r/20240528144345.5980-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/percpu-defs.h~percpu-add-__this_cpu_try_cmpxchg
+++ a/include/linux/percpu-defs.h
@@ -475,6 +475,12 @@ do {									\
 	raw_cpu_cmpxchg(pcp, oval, nval);				\
 })
 
+#define __this_cpu_try_cmpxchg(pcp, ovalp, nval)			\
+({									\
+	__this_cpu_preempt_check("try_cmpxchg");			\
+	raw_cpu_try_cmpxchg(pcp, ovalp, nval);				\
+})
+
 #define __this_cpu_sub(pcp, val)	__this_cpu_add(pcp, -(typeof(pcp))(val))
 #define __this_cpu_inc(pcp)		__this_cpu_add(pcp, 1)
 #define __this_cpu_dec(pcp)		__this_cpu_sub(pcp, 1)
_

Patches currently in -mm which might be from ubizjak@gmail.com are

fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

