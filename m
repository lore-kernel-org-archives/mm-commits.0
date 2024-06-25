Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACE8158A23
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 22:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719355940; cv=none; b=YMAXSkwo6nK0YLIcxRR/azVcDHw66KMC+3eLKjvHbGki6HKqBEfI52SJQDGSOZRbsm5bR9P++YBZhrkjNdHzZlaJr43xnZdgWrk1wrxlNSOf7bFCeXdRvhDC+LhJxznEvaxjeJQzO00ZF17rcCp9F74B2uvoSlvK/bDiQWW6hu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719355940; c=relaxed/simple;
	bh=54J+pSRIR9L53YOAMHfK280Y4iQBh7vgVwdjoVHa75w=;
	h=Date:To:From:Subject:Message-Id; b=ObIk5OVrgANJg31/jJarOzUTWbr8cmOvtrozYzzW6IKsIN3WFXADUQwgSnQexY2y8rNxD5U8F/P/oXeyMTU1SkZ+05DP1heNvXFsTyaKaRTiD+mYw9O2Kj8g6SOPKofwP8tA0jomwX57E9Axv5/Y6z2oddGAja+Gw3h5kt8hCgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UzeyqOrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzeyqOrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8214C32781;
	Tue, 25 Jun 2024 22:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719355939;
	bh=54J+pSRIR9L53YOAMHfK280Y4iQBh7vgVwdjoVHa75w=;
	h=Date:To:From:Subject:From;
	b=UzeyqOrMzJSHQ55lWi07Avx7s67rQYhCpzX3M5bF6HiPF+JL1BIX1ZiyC0N3f/Ygz
	 bSUSgGV/pfiUymWKE6LS4HBGltzeFF6fhHpm/jYgYJl+IpNWfpSIJ19aoisFQwGqK7
	 NnvzkPJMO3DDZBdPsswHIKxBeNFJjtvhI1e6Lmg0=
Date: Tue, 25 Jun 2024 15:52:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,hannes@cmpxchg.org,anna-maria@linutronix.de,shivamurthy.shastri@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath.patch removed from -mm tree
Message-Id: <20240625225219.C8214C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: fix -Wenum-enum-conversion warning in vmstat.h
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Shivamurthy Shastri <shivamurthy.shastri@linutronix.de>
Subject: mm/vmstat: fix -Wenum-enum-conversion warning in vmstat.h
Date: Fri, 21 Jun 2024 13:16:04 +0200

A W=1 build with -Wenum-enum-conversion enabled, results in the following
build warning due to an arithmetic operation between different enumeration
types 'enum node_stat_item' and 'enum lru_list':

  include/linux/vmstat.h:514:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
    514 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
        |                               ~~~~~~~~~~~ ^ ~~~

Address this by casting lru to the proper type.

Link: https://lkml.kernel.org/r/20240621111604.25330-1-shivamurthy.shastri@linutronix.de
Signed-off-by: Shivamurthy Shastri <shivamurthy.shastri@linutronix.de>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/vmstat.h~mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath
+++ a/include/linux/vmstat.h
@@ -495,7 +495,7 @@ static inline const char *node_stat_name
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 static inline const char *writeback_stat_name(enum writeback_stat_item item)
_

Patches currently in -mm which might be from shivamurthy.shastri@linutronix.de are


