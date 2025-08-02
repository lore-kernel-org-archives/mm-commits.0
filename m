Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561041A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161342; cv=none; b=uIxmFBOqsriHxVkjYHumxPO9zJzho1+hPkQCRSRa9/rPYeiTqY8vG3N1Uyw0PhlToinWPIll+hYGNxZB8JuJy5xS/Ff4IU/OcJ1d4rzsnkqCA/ZcbPFU+D7Eg0zQ93lQmvJP/sc3HtMcwQ29M89JdUzebVLbRt8BWIoF4EO4rnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161342; c=relaxed/simple;
	bh=HtVD0OXct3hYEWSByLptPAl2bc7JH6oEZJfvm9Qno40=;
	h=Date:To:From:Subject:Message-Id; b=HRjjwjWU9ckVMCzZqkiZnV0tBkuSNEKKO4Sc0vVaO2Yxzpsb5NKHekVGllt30++8V3JzrVR+BtkgqB14394xI7TfwlHRAwWXttgFxffpe9vJD3XK+OUOMfZSFbTYs3QW64MRT8OIVgKfNr/Wv8nULDmUh5b4wn2g5Su73GHrJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fJpru7z1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fJpru7z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3FCC4CEEF;
	Sat,  2 Aug 2025 19:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161341;
	bh=HtVD0OXct3hYEWSByLptPAl2bc7JH6oEZJfvm9Qno40=;
	h=Date:To:From:Subject:From;
	b=fJpru7z1MJyOr64/nihzDRjlY99JG+dRkGQ2jySmXxQ5uvvIAS1QHPbOnIpGtRzab
	 AcN+4WeP+wlwVPR4ghU92HbXgKgn3RbOevV0AqfW0BZ4J4IvQCeW84hdKYPnK8MmOG
	 HlcAp3cV0eA3EhTeKDRfHyqjpXxa+TGcKUc8Jpnc=
Date: Sat, 02 Aug 2025 12:02:21 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,krzk@kernel.org,fan.yu9@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-maintainers-for-delaytop.patch removed from -mm tree
Message-Id: <20250802190221.BC3FCC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add maintainers for delaytop
has been removed from the -mm tree.  Its filename was
     maintainers-add-maintainers-for-delaytop.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: MAINTAINERS: add maintainers for delaytop
Date: Mon, 21 Jul 2025 09:40:49 +0800 (CST)

The delaytop tool supports showing system delays and task-level delays,
effectively identifying the top-n tasks with high latency in the system,
which is highly beneficial for improving system performance.  Wang Yaxin
and her colleague Fan Yu focus on locating system delay issues.  To
promote the thriving development of delaytop, we hope to serve as
maintainers to continuously improve it, aiming to provide a more effective
solution for system latency issues in the future.

Link: https://lkml.kernel.org/r/20250721094049958ImB8XG_imntcPqpQn1KfG@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-add-maintainers-for-delaytop
+++ a/MAINTAINERS
@@ -19462,6 +19462,16 @@ S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
 
+TASK DELAY MONITORING TOOLS
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Wang Yaxin <wang.yaxin@zte.com.cn>
+M:	Fan Yu <fan.yu9@zte.com.cn>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/accounting/delay-accounting.rst
+F:	tools/accounting/delaytop.c
+F:	tools/accounting/getdelays.c
+
 PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


