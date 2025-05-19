Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932A8217733
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747691230; cv=none; b=qvNTbzp/0Kl7D/JK6Riv3xOnc+I8sgjrc+/a7K4dDNPwzhKlOrenmlXf5Rsjun767wxhgKPCyWay/YndRAT7eybt7Zv8HfLyn4LjD4oPRLytaeQVoO4EVZkYBijRqYXCXpkdabR+wdkQZia3mVyDo2Iv0uikOprFXjwf/W+suJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747691230; c=relaxed/simple;
	bh=buVWMsoo8luF7TTPvcg8rOz2ybLx27ezJV2RY4Le3fs=;
	h=Date:To:From:Subject:Message-Id; b=UBpcTKRZa6cuVoLibOLuPK+71EkFrh8Ka0O32O2a/Y511GmxtmdgJU2OY5MoSJJ5ifBX6An3g7SmDmzMj9UeTWv4ofxEizXmBqaynrtKYw+ZhMBnC8WOTZMCe+wdESfw5o9mRy2qNu6Qidci8v/JIrT41EzYcWX9Ir2MQpdVk4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hU3Ht0Eg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hU3Ht0Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E09C4CEE9;
	Mon, 19 May 2025 21:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747691228;
	bh=buVWMsoo8luF7TTPvcg8rOz2ybLx27ezJV2RY4Le3fs=;
	h=Date:To:From:Subject:From;
	b=hU3Ht0Eg0iEi2fJI/he5fclu1nA6XQ4tevshLIGwDzx6Qq9E6vF/aitcnJxLpu0ni
	 Htoo02Zv62TuvbdwZTXOz+gU1gUOwOarVnxuiGGRgS4pl6gcnF20HO2UGO+OSyUj05
	 Zf+yLkXqABu5GAncBeZ5xYdpERJC+3NdOX0viyoQ=
Date: Mon, 19 May 2025 14:47:08 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,jiang.kun2@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250519214708.C6E09C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
taskstats-fix-struct-taskstats-breaks-backward-compatibility-since-version-15-fix.patch

