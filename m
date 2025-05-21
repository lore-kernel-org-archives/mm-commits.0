Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BEE32C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806466; cv=none; b=Z5I+kfe8B4HlDDZ80B/W00EERZJL+pp1B3Pu73gF75gJ2rQYQVqiQ9y2e84ZfB0HltzQkdtmsbK4gzBggynlcdc9Syk9hT+NPQnDvDUuoRDlJQV/LEpARASwxYAS26LTREhqyrnM/FjYHu6+tfKlNOQmV3nlW5JTMZ9dpiETqsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806466; c=relaxed/simple;
	bh=cFSfMErSyvvmSn1Jd0epovbgD1F7boXds7mLaqiGTeU=;
	h=Date:To:From:Subject:Message-Id; b=MuG/46o9Nja25lvq65YfN7ZcDKx9ZSePn51sQ7X9WpZ1c5pr1mwXyYrm638MessUfM5DbHWpUeRjUduAk/q+BBIsiUMALGk0wCcDB2FlOfxHAWNn4L/AR6bRwa7h0blevWKvbNQkwXFhfbLF9rBmng03WhDVKcLA0aLU5Lg/f4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2jnLEiOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2jnLEiOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7BBC4CEE4;
	Wed, 21 May 2025 05:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806465;
	bh=cFSfMErSyvvmSn1Jd0epovbgD1F7boXds7mLaqiGTeU=;
	h=Date:To:From:Subject:From;
	b=2jnLEiODwC2sDVkaERwgPUZ79nvyGkqCehtFA4JfkhIR2RQMntDiDv3yFvvPG8zxe
	 bMRPh2mvXw3/2pe4EsgeYTVd2ORevrV0KT3T4kjcblkgRu+1t5s1oANW2YMvEeNCnm
	 WFvv/LOQExc06f6QdyarSoHtrOBlFOI5mJ65debc=
Date: Tue, 20 May 2025 22:47:45 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,jiang.kun2@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix.patch removed from -mm tree
Message-Id: <20250521054745.BD7BBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix
has been removed from the -mm tree.  Its filename was
     taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix.patch

This patch was dropped because it was folded into taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix
Date: Mon, 19 May 2025 21:31:48 +0800 (CST)

adjust indentation of xxx_delay_max/min in struct taskstats.

Link: https://lkml.kernel.org/r/202505192131489882NSciXV4EGd8zzjLuwoOK@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/taskstats.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/taskstats.h~taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix
+++ a/include/uapi/linux/taskstats.h
@@ -225,11 +225,11 @@ struct taskstats {
 	__u64	compact_delay_max;
 	__u64	compact_delay_min;
 
-	__u64    wpcopy_delay_max;
-	__u64    wpcopy_delay_min;
+	__u64	wpcopy_delay_max;
+	__u64	wpcopy_delay_min;
 
-	__u64    irq_delay_max;
-	__u64    irq_delay_min;
+	__u64	irq_delay_max;
+	__u64	irq_delay_min;
 };
 
 
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15.patch

