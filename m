Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5790A156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810168; cv=none; b=F6ZOxHE7TmDOtvhLihojgdAQLJTqfnQuRU9jWTxqtER3o6kVCFHJbMDYexScdnzpt8bRj5pQsdc3FZSdKczsEz5hlu0GqHcgd3b9FcZfStGwbFhZWrYT0a0MS2Dx1Kjhiyi9iWKToU95NfflJQAjiohvarqwQtOBqL5P4b2b6jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810168; c=relaxed/simple;
	bh=zJEUj9nSue0jz3Xxg2ymd6Av+Tt0ZbxSuypcYtUIsJY=;
	h=Date:To:From:Subject:Message-Id; b=RAsOgslSggodfHGcY36WyU0fhN4pm9eS6LHXpCrvZSdEm0PTYdCmTG6A+tp9x732PMrcg0mNvlz6BdqDv+JiLGMdz15K+5OPrx/EGFS/O9uOiOLLZAa3HDXuyxkpkGyxndOLaMv6Yqi6s560z7+p61s8lsRAlrcs/aUK/B48NiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mIkC48UQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mIkC48UQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC46C4CEEB;
	Sun, 14 Sep 2025 00:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810168;
	bh=zJEUj9nSue0jz3Xxg2ymd6Av+Tt0ZbxSuypcYtUIsJY=;
	h=Date:To:From:Subject:From;
	b=mIkC48UQPnRUB8XhmvhaqJ9CyciGCvkVhS50vl9QtKNphzEynOQm2cepKg8uKZOG1
	 RBPZDulr9m7gM1WR1V7EZsh1i6rZVyDAZhBqHDPFhmEmaDV1ORTtv7j+cWX+FnCJOr
	 e1fACsl4fyEazaAkz0FQOWdWK0FzIb1mPf0FKtTM=
Date: Sat, 13 Sep 2025 17:36:07 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docs-update-delaytop-documentation-for-new-interactive-features.patch removed from -mm tree
Message-Id: <20250914003608.2CC46C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: update delaytop documentation for new interactive features
has been removed from the -mm tree.  Its filename was
     docs-update-delaytop-documentation-for-new-interactive-features.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fan Yu <fan.yu9@zte.com.cn>
Subject: docs: update delaytop documentation for new interactive features
Date: Sun, 7 Sep 2025 00:14:57 +0800 (CST)

This commit updates the delaytop documentation to reflect the newly
added features:
1) Added comprehensive description of interactive keyboard controls
2) Documented all available sort fields
3) Added examples for advanced usage scenarios
4) Included PSI availability note

Link: https://lkml.kernel.org/r/20250907001457696qAqUGGkV1VfEO6OkVMovW@zte.com.cn
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |   89 ++++++++++------
 1 file changed, 57 insertions(+), 32 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~docs-update-delaytop-documentation-for-new-interactive-features
+++ a/Documentation/accounting/delay-accounting.rst
@@ -134,47 +134,72 @@ The above command can be used with -v to
 
 After the system starts, use `delaytop` to get the system-wide delay information,
 which includes system-wide PSI information and Top-N high-latency tasks.
+Note: PSI support requires `CONFIG_PSI=y` and `psi=1` for full functionality.
 
-`delaytop` supports sorting by CPU latency in descending order by default,
-displays the top 20 high-latency tasks by default, and refreshes the latency
-data every 2 seconds by default.
+`delaytop` is an interactive tool for monitoring system pressure and task delays.
+It supports multiple sorting options, display modes, and real-time keyboard controls.
 
-Get PSI information and Top-N tasks delay, since system boot::
+Basic usage with default settings (sorts by CPU delay, shows top 20 tasks, refreshes every 2 seconds)::
 
 	bash# ./delaytop
-	System Pressure Information: (avg10/avg60/avg300/total)
-	CPU some:       0.0%/   0.0%/   0.0%/     345(ms)
+	System Pressure Information: (avg10/avg60vg300/total)
+	CPU some:       0.0%/   0.0%/   0.0%/  106137(ms)
 	CPU full:       0.0%/   0.0%/   0.0%/       0(ms)
 	Memory full:    0.0%/   0.0%/   0.0%/       0(ms)
 	Memory some:    0.0%/   0.0%/   0.0%/       0(ms)
-	IO full:        0.0%/   0.0%/   0.0%/      65(ms)
-	IO some:        0.0%/   0.0%/   0.0%/      79(ms)
+	IO full:        0.0%/   0.0%/   0.0%/    2240(ms)
+	IO some:        0.0%/   0.0%/   0.0%/    2783(ms)
 	IRQ full:       0.0%/   0.0%/   0.0%/       0(ms)
-	Top 20 processes (sorted by CPU delay):
-	  PID   TGID  COMMAND          CPU(ms)  IO(ms) SWAP(ms) RCL(ms) THR(ms) CMP(ms)  WP(ms) IRQ(ms)
-	----------------------------------------------------------------------------------------------
-	  161    161  zombie_memcg_re   1.40    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	  130    130  blkcg_punt_bio    1.37    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	  444    444  scsi_tmf_0        0.73    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	 1280   1280  rsyslogd          0.53    0.04    0.00    0.00    0.00    0.00    0.00    0.00
-	   12     12  ksoftirqd/0       0.47    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	 1277   1277  nbd-server        0.44    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	  308    308  kworker/2:2-sys   0.41    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	   55     55  netns             0.36    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	 1187   1187  acpid             0.31    0.03    0.00    0.00    0.00    0.00    0.00    0.00
-	 6184   6184  kworker/1:2-sys   0.24    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	  186    186  kaluad            0.24    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	   18     18  ksoftirqd/1       0.24    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	  185    185  kmpath_rdacd      0.23    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	  190    190  kstrp             0.23    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	 2759   2759  agetty            0.20    0.03    0.00    0.00    0.00    0.00    0.00    0.00
-	 1190   1190  kworker/0:3-sys   0.19    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	 1272   1272  sshd              0.15    0.04    0.00    0.00    0.00    0.00    0.00    0.00
-	 1156   1156  license           0.15    0.11    0.00    0.00    0.00    0.00    0.00    0.00
-	  134    134  md                0.13    0.00    0.00    0.00    0.00    0.00    0.00    0.00
-	 6142   6142  kworker/3:2-xfs   0.13    0.00    0.00    0.00    0.00    0.00    0.00    0.00
+	[o]sort [M]memverbose [q]quit
+	Top 20 processes (sorted by cpu delay):
+		PID      TGID  COMMAND           CPU(ms)   IO(ms)  IRQ(ms)  MEM(ms)
+	------------------------------------------------------------------------
+		110       110  kworker/15:0H-s   27.91     0.00     0.00     0.00
+		57        57  cpuhp/7            3.18     0.00     0.00     0.00
+		99        99  cpuhp/14           2.97     0.00     0.00     0.00
+		51        51  cpuhp/6            0.90     0.00     0.00     0.00
+		44        44  kworker/4:0H-sy    0.80     0.00     0.00     0.00
+		60        60  ksoftirqd/7        0.74     0.00     0.00     0.00
+		76        76  idle_inject/10     0.31     0.00     0.00     0.00
+		100       100  idle_inject/14     0.30     0.00     0.00     0.00
+		1309      1309  systemsettings     0.29     0.00     0.00     0.00
+		45        45  cpuhp/5            0.22     0.00     0.00     0.00
+		63        63  cpuhp/8            0.20     0.00     0.00     0.00
+		87        87  cpuhp/12           0.18     0.00     0.00     0.00
+		93        93  cpuhp/13           0.17     0.00     0.00     0.00
+		1265      1265  acpid              0.17     0.00     0.00     0.00
+		1552      1552  sshd               0.17     0.00     0.00     0.00
+		2584      2584  sddm-helper        0.16     0.00     0.00     0.00
+		1284      1284  rtkit-daemon       0.15     0.00     0.00     0.00
+		1326      1326  nde-netfilter      0.14     0.00     0.00     0.00
+		27        27  cpuhp/2            0.13     0.00     0.00     0.00
+		631       631  kworker/11:2-rc    0.11     0.00     0.00     0.00
+
+Interactive keyboard controls during runtime::
+
+	o - Select sort field (CPU, IO, IRQ, Memory, etc.)
+	M - Toggle display mode (Default/Memory Verbose)
+	q - Quit
+
+Available sort fields(use -s/--sort or interactive command)::
+
+	cpu(c)       - CPU delay
+	blkio(i)     - I/O delay
+	irq(q)       - IRQ delay
+	mem(m)       - Total memory delay
+	swapin(s)    - Swapin delay (memory verbose mode only)
+	freepages(r) - Freepages reclaim delay (memory verbose mode only)
+	thrashing(t) - Thrashing delay (memory verbose mode only)
+	compact(p)   - Compaction delay (memory verbose mode only)
+	wpcopy(w)    - Write page copy delay (memory verbose mode only)
 
-Dynamic interactive interface of delaytop::
+Advanced usage examples::
+
+	# ./delaytop -s blkio
+	Sorted by IO delay
+
+	# ./delaytop -s mem -M
+	Sorted by memory delay in memory verbose mode
 
 	# ./delaytop -p pid
 	Print delayacct stats
_

Patches currently in -mm which might be from fan.yu9@zte.com.cn are


