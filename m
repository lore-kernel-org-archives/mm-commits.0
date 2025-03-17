Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6739140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189537; cv=none; b=sBcNwBTISqB5BXELzH+9AojLEHnzDPGEpJelhmYpW//2jWfV+cJCjBS6+/Dj6cGs9y8eOFs3RlWtD+eo2M8MPWF+SoRUL82RZL74OmVIKotgeHLnhV0U8SVBVU/m2kjIUvvVuNcl6TKxS1ZId9Lidu4MVyKOuRrhZ0S49TiWM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189537; c=relaxed/simple;
	bh=RqjTa41erti7ANFJ/pRalaSN5jr1tGxYQFk/tQO2UUs=;
	h=Date:To:From:Subject:Message-Id; b=Z3XTs/U8jqtDCsgRhx+EtOD0NQAHQwsIODt4ZfSulSHjTtN86AjFm3f7zSyk8C7eHeizCvHFR68Ut5UCL7OpY395MSrTTXBY/uPL8xrwTNgG4e2YeEovocWUQf1Debt0LuXrVdCVmGBMPGPTGqwgvB7zzFLr4myIdcUBnUDLx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1E4tJZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1E4tJZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A472C4CEEC;
	Mon, 17 Mar 2025 05:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189537;
	bh=RqjTa41erti7ANFJ/pRalaSN5jr1tGxYQFk/tQO2UUs=;
	h=Date:To:From:Subject:From;
	b=n1E4tJZ+tUj7V/9ExnFEOqMiERTua7u7wHZqITRhDTsxPJQ4rHUDBp/VNaxKQ6YVu
	 d/S6Qba96WwkubXEDoVjJmX1WpzHzcaVl41TVYKzUOEWbNnYi32Vkg+FPcCTfUDsnS
	 g5Zbo6qL803hEkE+V1RDUxCd9ZoxMUH+QnvVi+PE=
Date: Sun, 16 Mar 2025 22:32:16 -0700
To: mm-commits@vger.kernel.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch removed from -mm tree
Message-Id: <20250317053217.7A472C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpu: remove needless return in void API suspend_enable_secondary_cpus()
has been removed from the -mm tree.  Its filename was
     cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: cpu: remove needless return in void API suspend_enable_secondary_cpus()
Date: Fri, 21 Feb 2025 05:02:07 -0800

Remove needless 'return' in void API suspend_enable_secondary_cpus() since
both the API and thaw_secondary_cpus() are void functions.

Link: https://lkml.kernel.org/r/20250221-rmv_return-v1-2-cc8dff275827@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/cpu.h~cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus
+++ a/include/linux/cpu.h
@@ -148,7 +148,7 @@ static inline int suspend_disable_second
 }
 static inline void suspend_enable_secondary_cpus(void)
 {
-	return thaw_secondary_cpus();
+	thaw_secondary_cpus();
 }
 
 #else /* !CONFIG_PM_SLEEP_SMP */
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are


