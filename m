Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47761411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756843; cv=none; b=HzR6dZe0MvWB+NTt89vpzOOBXj6rWFE2YVxcuQCls1QufwbugQawUUwmUJTJW8RXZGDjwUZl1yKGSa/eEs5gFuI7zSyStQXjQ3TbytGdbEt0Lt/2q3qWiq0D9YDCw5PzBx2pErt8foJ+Cn4BdFZT9DFQ1Gh0kW8hur6GGh1aVv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756843; c=relaxed/simple;
	bh=5n5nDz1KC40ILsTrnTOs/GPFt3IMM7olnJRAdpfAv44=;
	h=Date:To:From:Subject:Message-Id; b=VWm2pLfPpa5dPFbUDAwsCB6kCYp4BuiWcwYZs7PWr4w2pGmhf6Ta2l4mIMCsuOOMjh1DjjHkvcNeqwxU45ENsfzYkbb5sjDK58D4zrcCn8GJX0iacf7f3lRXeGT7VJSg6AQTfoEUWlnSSVDbs1aIKdZB+zayO1mjuXaq9eWCyWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cb8iF8Ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cb8iF8Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A11C4CEED;
	Sun,  1 Jun 2025 05:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756843;
	bh=5n5nDz1KC40ILsTrnTOs/GPFt3IMM7olnJRAdpfAv44=;
	h=Date:To:From:Subject:From;
	b=Cb8iF8AyLS3Wbh2aYYK6nRuSWMfvWWOWq+2hNxvxnfk+VzcfAfIaRDd3PDF4DJKfq
	 JtOmqtakXCt2eqOhv+acp4wI9MVJ/7cxomPbD0LqVRbMoppYA5AcPU6e74iUEWO4lk
	 mZAl2tb/PwY+8bLmHdLjjP9OgA1PqcTIonrYAPEE=
Date: Sat, 31 May 2025 22:47:23 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-kconfig-enable-config_damon-by-default.patch removed from -mm tree
Message-Id: <20250601054723.A8A11C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/Kconfig: enable CONFIG_DAMON by default
has been removed from the -mm tree.  Its filename was
     mm-damon-kconfig-enable-config_damon-by-default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/Kconfig: enable CONFIG_DAMON by default
Date: Tue, 20 May 2025 21:27:55 -0700

As of this writing, multiple major distros including Alma, Amazon,
Android, CentOS, Debian, Fedora, and Oracle are build-enabling DAMON (set
CONFIG_DAMON[1]).  Enabling it by default will save configuration setup
time for the current and future DAMON users.

Build-enabling DAMON does not introduce a real risk since it makes no
behavioral change by default.  It requires explicit user requests to do
anything.  Only one potential risk is making the size of the kernel a
little bit larger.  On a production-purpose configuration, it increases
the resulting kernel package size by about 0.1 % of the final package
file.  I believe that's too small to be a real problem in common setups.

Hence, the benefit of enabling CONFIG_DAMON outweighs the potential risk. 
Set CONFIG_DAMON by default.

Link: https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON [1]
Link: https://lkml.kernel.org/r/20250521042755.39653-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/Kconfig~mm-damon-kconfig-enable-config_damon-by-default
+++ a/mm/damon/Kconfig
@@ -4,6 +4,7 @@ menu "Data Access Monitoring"
 
 config DAMON
 	bool "DAMON: Data Access Monitoring Framework"
+	default y
 	help
 	  This builds a framework that allows kernel subsystems to monitor
 	  access frequency of each memory region. The information can be useful
_

Patches currently in -mm which might be from sj@kernel.org are


