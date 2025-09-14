Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349F918B0F
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757808974; cv=none; b=RWQRsja3wdXJ6F/vybIZRCipUhY81A9IEp7XSpb/Q7I/I5oNV+Vx0vhW2oKRo8eDUzr6tVGOxuUXR2VajQjyd6bCUorDk6/eetlTgnC7Ex//OgIX8j89x5U9bXUCPHQdJdrrnMI/Yt47fknDIoTCp8Ijt9t9bDMzukI+YYJJHag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757808974; c=relaxed/simple;
	bh=2LHbw8+EZnUcBQPpeSpAr1jHh7cddkmtTarv0rg8e9E=;
	h=Date:To:From:Subject:Message-Id; b=XJEeD52F+mICbwOLOb/P2cNk1fkg51K9vUTHVj2maqndAEVoju6281ofFBAHlIzNJB7Zto28EMRhWS9jIGuOIc18b+fCQ7lJHAmVOYtr0bc//IjKAHQgRsbMqxw49RwOP5eihS3l3sKswN9LhxOMBcjGXDBTXL3FhZXRPL5HSEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DNFoe9GL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DNFoe9GL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC5BC4CEEB;
	Sun, 14 Sep 2025 00:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757808973;
	bh=2LHbw8+EZnUcBQPpeSpAr1jHh7cddkmtTarv0rg8e9E=;
	h=Date:To:From:Subject:From;
	b=DNFoe9GLeQ0s1jep/mBVeksVpzizC4fiBVGjM5ZdM5FGx3Xc+JYdINjCe8g1vgpkT
	 6tN2V9PjHzZeC4HC8YXgpPGASdcItvz1zTf035i9HO9VP96cIEiDYaOZIiiu6sG9YQ
	 rhWNGTRZiU3r3fFxQaxlMbtlO4czO4t03fTFU6G0=
Date: Sat, 13 Sep 2025 17:16:13 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,tglx@linutronix.de,max.kellermann@ionos.com,lihuafei1@huawei.com,yaozhenguo1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2.patch removed from -mm tree
Message-Id: <20250914001613.9FC5BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/softlockup:Fix incorrect CPU utilization output during softlockup
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2.patch

This patch was dropped because it was folded into watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch

------------------------------------------------------
From: ZhenguoYao <yaozhenguo1@gmail.com>
Subject: watchdog/softlockup:Fix incorrect CPU utilization output during softlockup
Date: Mon, 18 Aug 2025 16:14:38 +0800

make get_16bit_precision() more accurate, fix comment layout

Link: https://lkml.kernel.org/r/20250818081438.40540-1-yaozhenguo@jd.com
Signed-off-by: ZhenguoYao <yaozhenguo1@gmail.com>
Cc: Bitao Hu <yaoma@linux.alibaba.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2
+++ a/kernel/watchdog.c
@@ -425,7 +425,11 @@ static DEFINE_PER_CPU(u8, cpustat_tail);
  */
 static u16 get_16bit_precision(u64 data_ns)
 {
-	return data_ns >> 24LL; /* 2^24ns ~= 16.8ms */
+	/*
+	 * 2^24ns ~= 16.8ms
+	 * Round to the nearest multiple of 16.8 milliseconds.
+	 */
+	return (data_ns + (1 << 23)) >> 24LL;
 }
 
 static void update_cpustat(void)
@@ -444,7 +448,8 @@ static void update_cpustat(void)
 		old_stat = __this_cpu_read(cpustat_old[i]);
 		new_stat = get_16bit_precision(cpustat[tracked_stats[i]]);
 		util = DIV_ROUND_UP(100 * (new_stat - old_stat), sample_period_16);
-		/* Since we use 16-bit precision, the raw data will undergo
+		/*
+		 * Since we use 16-bit precision, the raw data will undergo
 		 * integer division, which may sometimes result in data loss,
 		 * and then result might exceed 100%. To avoid confusion,
 		 * we enforce a 100% display cap when calculations exceed this threshold.
_

Patches currently in -mm which might be from yaozhenguo1@gmail.com are

watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch
watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch

