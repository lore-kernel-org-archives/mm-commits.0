Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAAD1CEAD6
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 02:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748400056; cv=none; b=KUSRfU1nX6ylKjdmq6ub9S0pvANz4lP8OEB9WA5M0V1+zZN9AMJ2K3u+1FxT7CPfxe0aaZtf4DYdEcxEMz96BkKzcJIyyka4Bj4L/LjnrpXMqdt+njbPN1gsUF0xUonswkNOkqbJZBq3rjU8JLaQCMCrwNzfEDIe5kwOKY7y6kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748400056; c=relaxed/simple;
	bh=WergUAJILz18nx5f0EXUOCSvAOEf90i46KcRsoO/VKs=;
	h=Date:To:From:Subject:Message-Id; b=BZOEaKjHIbMBGl1YdAfBQHKa44bY/I9vOHxgsDtF1+W4z/8Jg2YYIMKpwLBXTzWex9a/ho4bsBnSXOjI4o90nNGkPQqDX4AM1JTHFaC5kZsnpRO9wQum6Ij0uaYf44bCc51k9zHZ5DffnMbfdzFR41vhBS8UQiuzDGHV5GboEyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l+CSxg6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l+CSxg6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66C5C4CEE9;
	Wed, 28 May 2025 02:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748400055;
	bh=WergUAJILz18nx5f0EXUOCSvAOEf90i46KcRsoO/VKs=;
	h=Date:To:From:Subject:From;
	b=l+CSxg6mTNIrBSn3SKHUUt48JfVXzKfofDD80zOr7ojyffM5k8KKwr0+/9cLnPaLd
	 32ix0wymxhnm48W/TBqH2ZUM+x3XbI9uNuES7jih1Xf8RRlNjmaJYpQFTbmy78uNMt
	 Y2wdGB9dQdeRjMRxWgolICvudv3T1lt9p6TRAbAk=
Date: Tue, 27 May 2025 19:40:55 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,jiang.kun2@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] delayacct-remove-redundant-code-and-adjust-indentation.patch removed from -mm tree
Message-Id: <20250528024055.B66C5C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delayacct: remove redundant code and adjust indentation
has been removed from the -mm tree.  Its filename was
     delayacct-remove-redundant-code-and-adjust-indentation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delayacct: remove redundant code and adjust indentation
Date: Wed, 21 May 2025 09:31:57 +0800 (CST)

Remove redundant code and adjust indentation of xxx_delay_max/min.

Link: https://lkml.kernel.org/r/20250521093157668iQrhhcMjA-th5LQf4-A3c@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/delayacct.c |   51 +++++++++++++------------------------------
 1 file changed, 16 insertions(+), 35 deletions(-)

--- a/kernel/delayacct.c~delayacct-remove-redundant-code-and-adjust-indentation
+++ a/kernel/delayacct.c
@@ -14,6 +14,15 @@
 #include <linux/delayacct.h>
 #include <linux/module.h>
 
+#define UPDATE_DELAY(type) \
+do { \
+	d->type##_delay_max = tsk->delays->type##_delay_max; \
+	d->type##_delay_min = tsk->delays->type##_delay_min; \
+	tmp = d->type##_delay_total + tsk->delays->type##_delay; \
+	d->type##_delay_total = (tmp < d->type##_delay_total) ? 0 : tmp; \
+	d->type##_count += tsk->delays->type##_count; \
+} while (0)
+
 DEFINE_STATIC_KEY_FALSE(delayacct_key);
 int delayacct_on __read_mostly;	/* Delay accounting turned on/off */
 struct kmem_cache *delayacct_cache;
@@ -173,41 +182,13 @@ int delayacct_add_tsk(struct taskstats *
 
 	/* zero XXX_total, non-zero XXX_count implies XXX stat overflowed */
 	raw_spin_lock_irqsave(&tsk->delays->lock, flags);
-	d->blkio_delay_max = tsk->delays->blkio_delay_max;
-	d->blkio_delay_min = tsk->delays->blkio_delay_min;
-	tmp = d->blkio_delay_total + tsk->delays->blkio_delay;
-	d->blkio_delay_total = (tmp < d->blkio_delay_total) ? 0 : tmp;
-	d->swapin_delay_max = tsk->delays->swapin_delay_max;
-	d->swapin_delay_min = tsk->delays->swapin_delay_min;
-	tmp = d->swapin_delay_total + tsk->delays->swapin_delay;
-	d->swapin_delay_total = (tmp < d->swapin_delay_total) ? 0 : tmp;
-	d->freepages_delay_max = tsk->delays->freepages_delay_max;
-	d->freepages_delay_min = tsk->delays->freepages_delay_min;
-	tmp = d->freepages_delay_total + tsk->delays->freepages_delay;
-	d->freepages_delay_total = (tmp < d->freepages_delay_total) ? 0 : tmp;
-	d->thrashing_delay_max = tsk->delays->thrashing_delay_max;
-	d->thrashing_delay_min = tsk->delays->thrashing_delay_min;
-	tmp = d->thrashing_delay_total + tsk->delays->thrashing_delay;
-	d->thrashing_delay_total = (tmp < d->thrashing_delay_total) ? 0 : tmp;
-	d->compact_delay_max = tsk->delays->compact_delay_max;
-	d->compact_delay_min = tsk->delays->compact_delay_min;
-	tmp = d->compact_delay_total + tsk->delays->compact_delay;
-	d->compact_delay_total = (tmp < d->compact_delay_total) ? 0 : tmp;
-	d->wpcopy_delay_max = tsk->delays->wpcopy_delay_max;
-	d->wpcopy_delay_min = tsk->delays->wpcopy_delay_min;
-	tmp = d->wpcopy_delay_total + tsk->delays->wpcopy_delay;
-	d->wpcopy_delay_total = (tmp < d->wpcopy_delay_total) ? 0 : tmp;
-	d->irq_delay_max = tsk->delays->irq_delay_max;
-	d->irq_delay_min = tsk->delays->irq_delay_min;
-	tmp = d->irq_delay_total + tsk->delays->irq_delay;
-	d->irq_delay_total = (tmp < d->irq_delay_total) ? 0 : tmp;
-	d->blkio_count += tsk->delays->blkio_count;
-	d->swapin_count += tsk->delays->swapin_count;
-	d->freepages_count += tsk->delays->freepages_count;
-	d->thrashing_count += tsk->delays->thrashing_count;
-	d->compact_count += tsk->delays->compact_count;
-	d->wpcopy_count += tsk->delays->wpcopy_count;
-	d->irq_count += tsk->delays->irq_count;
+	UPDATE_DELAY(blkio);
+	UPDATE_DELAY(swapin);
+	UPDATE_DELAY(freepages);
+	UPDATE_DELAY(thrashing);
+	UPDATE_DELAY(compact);
+	UPDATE_DELAY(wpcopy);
+	UPDATE_DELAY(irq);
 	raw_spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 	return 0;
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


