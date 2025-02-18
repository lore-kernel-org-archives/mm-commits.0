Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384861B4227
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860855; cv=none; b=g0P2TB6uWVfZqoUpAw9WL16rUJNEoxQYvql0a6M5YP/tC5IBjG0kku3zI1+ZWcUqc0xQRLqPoadW48TxrMP/YgW87kvAD7GyXTZpmfOlAuQamKg7W1+JIenJVMfp7O8mmM7subwac1rl+cs9Mgrl3x5kIX3v+MdlgT5uy8aJs1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860855; c=relaxed/simple;
	bh=jt0OAzzLr+x6iblkjHJHlLtZ1mLtWQltRYdIvy638wE=;
	h=Date:To:From:Subject:Message-Id; b=TjcJ4mLWyMb079nrQm2+EU1oVv8rf8Qw5FQpzLt8j4AtsvCiHZRxS5hUIzmqFwKfrqNC+moUjGB40LeCZMMilOvxI9cIGdabMyOome+DLHPaGP0X0r5uYUf7wUTG2sxwEI6FmVJXBx+/QPzWS7I5rusSXUsXFTY+Y41PjKITBlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1A/KsWsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1A/KsWsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4B8C4CEE2;
	Tue, 18 Feb 2025 06:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860854;
	bh=jt0OAzzLr+x6iblkjHJHlLtZ1mLtWQltRYdIvy638wE=;
	h=Date:To:From:Subject:From;
	b=1A/KsWshv5ywOqdaUxh7GknurEP5UDtYvUV13GulK3/RB/o4Upqvm7a874SN0JQmy
	 /eZeh3OCa8B+svj7a9/G/86BtfPUmGpIFtgcAoDsUxSSYNaPbFnrOrI1PN4n8G2bhI
	 dzTzoVwUwLOMgIjSWQTW2jXa6PZe5SuusqRA1XRo=
Date: Mon, 17 Feb 2025 22:40:53 -0800
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,jiang.kun2@zte.com.cn,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] taskstats-modify-taskstats-version.patch removed from -mm tree
Message-Id: <20250218064054.8F4B8C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: modify taskstats version
has been removed from the -mm tree.  Its filename was
     taskstats-modify-taskstats-version.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: taskstats: modify taskstats version
Date: Sat, 8 Feb 2025 14:49:01 +0800 (CST)

After adding "delay max" and "delay min" to the taskstats structure, the
taskstats version needs to be updated.

Link: https://lkml.kernel.org/r/20250208144901218Q5ptVpqsQkb2MOEmW4Ujn@zte.com.cn
Fixes: f65c64f311ee ("delayacct: add delay min to record delay peak")
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/taskstats.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/taskstats.h~taskstats-modify-taskstats-version
+++ a/include/uapi/linux/taskstats.h
@@ -34,7 +34,7 @@
  */
 
 
-#define TASKSTATS_VERSION	14
+#define TASKSTATS_VERSION	15
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


