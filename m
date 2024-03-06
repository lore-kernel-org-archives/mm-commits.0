Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9ABBE4D
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759099; cv=none; b=Y/cg6BfCWWMjVtnrS27UgfZvvHI9pXoNEqgYJYyUbtXBFw3/N65Kt8YZPMXLYZDoM7ntC/ItYBNMetxid/76y9h44r/msAsldpMvBPW3n11iCl8ML+sXR5V3YVBV+9P0Nfs7LFujSxe4McsHJv0glIrCPBHhJsMJ/teZHjFawRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759099; c=relaxed/simple;
	bh=s2eJ0G1odN7ct9kknbRQMjfjSRCOgTBICIn3hNpCWXU=;
	h=Date:To:From:Subject:Message-Id; b=JAn8kgxE4m30xqJ3TZBf0bfIPKPJgBa9+3GJ1XIVE7JJRoFFti6erlDLsELN+e2pMisqQD9RH3ljqrWFFt1xIN6Z3YSGhhmmQpG9pAJp8074WVnMfVfJefSaIWHyXXkjybedWstX8GBP5GpFkHQPhXToqcRocnCsmm71pkKSW4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1yV7r4CY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1yV7r4CY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFC8C43390;
	Wed,  6 Mar 2024 21:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759098;
	bh=s2eJ0G1odN7ct9kknbRQMjfjSRCOgTBICIn3hNpCWXU=;
	h=Date:To:From:Subject:From;
	b=1yV7r4CYhN4fwr3kPnkgIWtdyBOWwOh9ovz5QEeGUDPD65IyPBMVDBMEC9jFsEtVK
	 HmAFbS2gD20FJOGoTF7VGr+6lQIQb4Q/ZyGysKkfttobBoNovhZgKAMDaquKDwWr5x
	 tY/vwBBE3lxaJEsemGQ334SyAYEwHzZ/BIuAfZLk=
Date: Wed, 06 Mar 2024 13:04:58 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,steffen.klassert@secunet.com,rientjes@google.com,rdunlap@infradead.org,paulmck@kernel.org,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,jane.chu@oracle.com,david@redhat.com,daniel.m.jordan@oracle.com,adobriyan@gmail.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch removed from -mm tree
Message-Id: <20240306210458.9DFC8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: padata: downgrade padata_do_multithreaded to serial execution for non-SMP
has been removed from the -mm tree.  Its filename was
     padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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


