Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE1E16DEB3
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977380; cv=none; b=QBfcjP0Hv0Au8aRVGzGZYkf+a61zupg0Akue6aYXzJ3lzwVIbVhEUX18Gr2zsC1hZUjRq/SL7fjYUfgGSVYpzqRQW1CtFa/Sk4Dun+dIqi9TsGMqdOexyR9x1be/9oMJZaDf1JmZ9kUpGRGV6Za0j9QKKK9Y07fdwiSToNkuMd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977380; c=relaxed/simple;
	bh=Uy0X5EAS0wau1+rVTLxomk8Wagn4YcL6+Z+6pWSBdRQ=;
	h=Date:To:From:Subject:Message-Id; b=dK38X/TgGEPYid2OHTd0y68S72OjsFeSvrz3Ux2d4cjG/TPKx8/dWxJJ/VlbusPUZXdvgtXjx+CBETpnS7qHWOGrQqBsi7X6yJcarDYVy1pVH7Epb2j9samADwlo6YiQwgn0zHxcNihsBN6V9Za+WRFNCDc4Egkhx4EmBk7HSXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ax15nVm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ax15nVm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E975C4CEE3;
	Sun, 20 Jul 2025 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977380;
	bh=Uy0X5EAS0wau1+rVTLxomk8Wagn4YcL6+Z+6pWSBdRQ=;
	h=Date:To:From:Subject:From;
	b=ax15nVm5zV7O4BudHiDJv7Ife6lC0GJg/8hRVnWNRQgYLd5rSb98me18e2F5aC+JS
	 yKxh5+YALom157S11uy9SBR7MmgxOWPAzDL+zfaBdZRCbrhdls6InwvfT3f7L3rbsJ
	 O40DQTvW6EejOVfTl/Hu6sg6f/cN1T8ce96D3cac=
Date: Sat, 19 Jul 2025 19:09:40 -0700
To: mm-commits@vger.kernel.org,zhang.yunkai@zte.com.cn,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yong12@zte.com.cn,tu.qiang35@zte.com.cn,jiang.kun2@zte.com.cn,he.peilin@zte.com.cn,fan.yu9@zte.com.cn,david@redhat.com,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docs-update-docs-after-introducing-delaytop.patch removed from -mm tree
Message-Id: <20250720020940.7E975C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: update docs after introducing delaytop
has been removed from the -mm tree.  Its filename was
     docs-update-docs-after-introducing-delaytop.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: docs: update docs after introducing delaytop
Date: Thu, 10 Jul 2025 13:51:41 +0800 (CST)

The "getdelays" can only display the latency of a single task by
specifying a PID, we introduce the "delaytop" with the following
capabilities:

1. system view: monitors latency metrics (CPU, I/O, memory, IRQ, etc.)
   for all system processes

2. supports field-based sorting (e.g., default sort by CPU latency in
   descending order)

3. dynamic interactive interface: focus on specific processes with
   --pid; limit displayed entries with --processes 20; control monitoring
   duration with --iterations;

Link: https://lkml.kernel.org/r/2025071013514177028RdjISjqeIOnTCRvGAwy@zte.com.cn
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peilin He <he.peilin@zte.com.cn>
Cc: Qiang Tu <tu.qiang35@zte.com.cn>
Cc: wangyong <wang.yong12@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |   47 ++++++++++++++++
 1 file changed, 47 insertions(+)

--- a/Documentation/accounting/delay-accounting.rst~docs-update-docs-after-introducing-delaytop
+++ a/Documentation/accounting/delay-accounting.rst
@@ -131,3 +131,50 @@ Get IO accounting for pid 1, it works on
 	linuxrc: read=65536, write=0, cancelled_write=0
 
 The above command can be used with -v to get more debug information.
+
+After the system starts, use `delaytop` to get the Top-N high-latency tasks.
+this tool supports sorting by CPU latency in descending order by default,
+displays the top 20 high-latency tasks by default, and refreshes the latency
+data every 2 seconds by default.
+
+Get Top-N tasks delay, since system boot::
+
+	bash# ./delaytop
+	Top 20 processes (sorted by CPU delay):
+
+	  PID   TGID  COMMAND            CPU(ms)  IO(ms)        SWAP(ms) RCL(ms) THR(ms)  CMP(ms)  WP(ms)  IRQ(ms)
+	---------------------------------------------------------------------------------------------
+	   32     32  kworker/2:0H-sy   23.65     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	  497    497  kworker/R-scsi_    1.20     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	  495    495  kworker/R-scsi_    1.13     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	  494    494  scsi_eh_0          1.12     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	  485    485  kworker/R-ata_s    0.90     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	  574    574  kworker/R-kdmfl    0.36     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	   34     34  idle_inject/3      0.33     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	 1123   1123  nde-netfilter      0.28     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	   60     60  ksoftirqd/7        0.25     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	  114    114  kworker/0:2-cgr    0.25     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	  496    496  scsi_eh_1          0.24     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	   51     51  cpuhp/6            0.24     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	 1667   1667  atd                0.24     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	   45     45  cpuhp/5            0.23     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	 1102   1102  nde-backupservi    0.22     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	 1098   1098  systemsettings     0.21     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	 1100   1100  audit-monitor      0.20     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	   53     53  migration/6        0.20     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	 1482   1482  sshd               0.19     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+	   39     39  cpuhp/4            0.19     0.00     0.00     0.00    0.00     0.00     0.00     0.00
+
+Dynamic interactive interface of delaytop::
+
+	# ./delaytop -p pid
+	Print delayacct stats
+
+	# ./delaytop -P num
+	Display the top N tasks
+
+	# ./delaytop -n num
+	Set delaytop refresh frequency (num times)
+
+	# ./delaytop -d secs
+	Specify refresh interval as secs
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


