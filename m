Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC991079A
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560059; cv=none; b=rVB4cYqYFJ2bGh36zSLQCw83aw34S6XiQHZcz0XSByyqnWsvfb/Ashmf2jelp7I3nX5OLpCQ/02wtM7+bRiJlnx3VqJpHLCC2xxZeohEtdeR2NlE4emieGJE91UxrgEC/p69J669IZgpFVZg773EojUoHg73YRJyAvXkoUT1GL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560059; c=relaxed/simple;
	bh=11walLIthYvjKQlyefdAa9M3caPDL2CvgkhPSto64aA=;
	h=Date:To:From:Subject:Message-Id; b=r3UZ0/N1j2tCCpiBjjYN4UIO01YeVoGUNMTvoOr2Cm4jRfraHdKzzRWlaJI/ea5C1UvW4tsBIu1cTn0FQv/T8Ra/hYaUH0yML70utWQO3l7GtumQ1GB3unAIWi85c4+EOraeYBxfAVA8gAZ/Mt/RLf7t5KYZVns5crBZjRQ7Too=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r4ihnQ92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r4ihnQ92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFDDC43399;
	Thu, 22 Feb 2024 00:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560059;
	bh=11walLIthYvjKQlyefdAa9M3caPDL2CvgkhPSto64aA=;
	h=Date:To:From:Subject:From;
	b=r4ihnQ92z7kxJwGdaEdraJCdmfxeWODjPkvh7lNFkVZFWbZLwnucBP1Qd8P/pv+gB
	 ZcaeI5DmRbpWp27GXJMR2BiLEwvCLmkXnkL423KIL4Dt+fQJKuoBGWqu7QIK+Mgzy7
	 1/6j71nC0Chs1M1vq6KMvo/amDQpLjXrRhVWX/ew=
Date: Wed, 21 Feb 2024 16:00:59 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-sclp-remove-unhandled-memory-notifier-type.patch removed from -mm tree
Message-Id: <20240222000059.9DFDDC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/sclp: remove unhandled memory notifier type
has been removed from the -mm tree.  Its filename was
     s390-sclp-remove-unhandled-memory-notifier-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390/sclp: remove unhandled memory notifier type
Date: Mon, 8 Jan 2024 14:27:45 +0100

Remove memory notifier types which are unhandled by s390.  Unhandled
memory notifier types are covered by default case.

Link: https://lkml.kernel.org/r/20240108132747.3238763-4-sumanthk@linux.ibm.com
Suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cmd.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/s390/char/sclp_cmd.c~s390-sclp-remove-unhandled-memory-notifier-type
+++ a/drivers/s390/char/sclp_cmd.c
@@ -340,9 +340,6 @@ static int sclp_mem_notifier(struct noti
 		if (contains_standby_increment(start, start + size))
 			rc = -EPERM;
 		break;
-	case MEM_ONLINE:
-	case MEM_CANCEL_OFFLINE:
-		break;
 	case MEM_GOING_ONLINE:
 		rc = sclp_mem_change_state(start, size, 1);
 		break;
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are


