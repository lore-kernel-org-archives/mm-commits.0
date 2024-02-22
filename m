Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82800548E0
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628938; cv=none; b=oTWsRIiDma7zwu/HvSWMJmc9YgqQ+cRlfr0INqtaOv5dx2pJpkXvcbApNvY0XGyv7Po04BQX61tb1UUfoBATCRmjFYDOXhmL3Yt6z6e/RzA4OOiSTqtTwk+tt4DCcd1wmW3JNKw9R9DQc+FCHjRartiqRE1WDfb7ngfHix+G8Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628938; c=relaxed/simple;
	bh=mmqWc7mQ5w7RYN34qduda0rkwcCYF5qgYQ4zojiWghE=;
	h=Date:To:From:Subject:Message-Id; b=DzAE6UzIsF/C8zRhUV6TLMKqJsr9kznSRmYNuHcrIsWYrc/O3DfyJ0bFA9MoQKebTt0pCM35CU0Z99aDUg3J6EBdOpBv1KVb0yXrVyB5k+F5qVuEjy5fXU/44KJnN3/GCZqAAlVTz699VXQKVZ4KrMlM1B+h/YIfj4TuikVsnUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=srY8PwUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="srY8PwUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0639FC433F1;
	Thu, 22 Feb 2024 19:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708628938;
	bh=mmqWc7mQ5w7RYN34qduda0rkwcCYF5qgYQ4zojiWghE=;
	h=Date:To:From:Subject:From;
	b=srY8PwUY1nqUzg/9ula4RZJ/A3ghwodUqTsOXxCIn5duxqOShFc8sZ4qwFW1lyWoO
	 CjbDGJNyu2mlVeOydNwfEvNHD87zxvPFgYEVaf/XD3Hho4dEXMCK2+gJX6roW69pGC
	 w1VrbaOhZhR7qP8bOP+NhjYtqc+JImwaM7dZrhUU=
Date: Thu, 22 Feb 2024 11:08:57 -0800
To: mm-commits@vger.kernel.org,paulmck@kernel.org,ligang.bdlg@bytedance.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch added to mm-unstable branch
Message-Id: <20240222190858.0639FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: padata: downgrade padata_do_multithreaded to serial execution for non-SMP
has been added to the -mm mm-unstable branch.  Its filename is
     padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch

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
From: Gang Li <gang.li@linux.dev>
Subject: padata: downgrade padata_do_multithreaded to serial execution for non-SMP
Date: Thu, 22 Feb 2024 22:04:18 +0800

hugetlb parallelization depends on PADATA, and PADATA depends on SMP.

PADATA consists of two distinct functionality: One part is
padata_do_multithreaded which disregards order and simply divides tasks
into several groups for parallel execution.  Hugetlb init parallelization
depends on padata_do_multithreaded.

The other part is composed of a set of APIs that, while handling data in
an out-of-order parallel manner, can eventually return the data with
ordered sequence.  Currently Only `crypto/pcrypt.c` use them.

All users of PADATA of non-SMP case currently only use
padata_do_multithreaded.  It is easy to implement a serial one in
include/linux/padata.h.  And it is not necessary to implement another
functionality unless the only user of crypto/pcrypt.c does not depend on
SMP in the future.

Link: https://lkml.kernel.org/r/20240222140422.393911-6-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/padata.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/padata.h~padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp
+++ a/include/linux/padata.h
@@ -180,10 +180,6 @@ struct padata_instance {
 
 #ifdef CONFIG_PADATA
 extern void __init padata_init(void);
-#else
-static inline void __init padata_init(void) {}
-#endif
-
 extern struct padata_instance *padata_alloc(const char *name);
 extern void padata_free(struct padata_instance *pinst);
 extern struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
@@ -194,4 +190,12 @@ extern void padata_do_serial(struct pada
 extern void __init padata_do_multithreaded(struct padata_mt_job *job);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
+#else
+static inline void __init padata_init(void) {}
+static inline void __init padata_do_multithreaded(struct padata_mt_job *job)
+{
+	job->thread_fn(job->start, job->start + job->size, job->fn_arg);
+}
+#endif
+
 #endif
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
padata-dispatch-works-on-different-nodes.patch
padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

