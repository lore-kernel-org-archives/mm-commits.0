Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F78172BBF
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 19:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716923261; cv=none; b=KsxrDNI2AtlU33zhDqW1pRXYazLtNVsRUpIsYR41BqL4oxlZWUBCDc4cPwP3sU1DjfZctBGR2HFo4IywfGfkcpD0/0cHuXV57FxBTaIW3aqU6SvziKks1RjBcZIscJM2vrm9NECCN1H/5WR0JWmCyCJ9KAQhcVTMAiXbyrVIyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716923261; c=relaxed/simple;
	bh=mC8zDFcA7QtP6aYFU3zb5inQrl9N+gpHnCZjZMKIJYc=;
	h=Date:To:From:Subject:Message-Id; b=PmPxvZ2ebcstdM6uLZqw0soPDxb11snezkW5nC60j9JtePvrfY/7R2wrupXBSI+dBDemc1MqvZM9+jeT+zErUOTbIaaz2M6ySmHSKOlfnprFiXHE1Nku55EKV0RL+LlDrIo+CiTC1gOHtIVT2chqIi+OYlWKW9MuNrzVp5f7AXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vc28tkjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vc28tkjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5387BC3277B;
	Tue, 28 May 2024 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716923261;
	bh=mC8zDFcA7QtP6aYFU3zb5inQrl9N+gpHnCZjZMKIJYc=;
	h=Date:To:From:Subject:From;
	b=vc28tkjpzRlMJfAClptiRFMWMa9d4PKyRvepTw3BXuLzURwnkSkooMkREXjgQzNkh
	 arCKdjDHlzF+RfTq1lvfyFAopVIim5vkdPsGcR53XRSDOSWY4xBJtqp5eNpVGFQwpZ
	 S4d+MGUChmGf4Ya/QR7BnOVR9bJDbNeKJlQP4QuY=
Date: Tue, 28 May 2024 12:07:40 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,tj@kernel.org,lstoakes@gmail.com,hch@infradead.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-add-__this_cpu_try_cmpxchg.patch added to mm-unstable branch
Message-Id: <20240528190741.5387BC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: add __this_cpu_try_cmpxchg()
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-add-__this_cpu_try_cmpxchg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-add-__this_cpu_try_cmpxchg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: add __this_cpu_try_cmpxchg()
Date: Tue, 28 May 2024 16:43:13 +0200

Add __this_cpu_try_cmpxchg() version of the percpu op.

Link: https://lkml.kernel.org/r/20240528144345.5980-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
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

percpu-add-__this_cpu_try_cmpxchg.patch
mm-vmalloc-use-__this_cpu_try_cmpxchg-in-preload_this_cpu_lock.patch
fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

