Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA2E1E5B72
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161351; cv=none; b=hfEb5YGEdQFKarRH3tXUoiKnUT95SQTT+OPGJQIo1SK4K5BAcwfYtdXEhcrmbQ/UbsbfXL8n7oaGgzWPPM4ZhBsVE5KBoAQe8eh8HrLhG3gISdv8HvOhaQFS+tv+rRqv4BfCu8lZ/J+Bm1ZbjvNgB+vkoGO3HD4uO/MQqouRmW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161351; c=relaxed/simple;
	bh=3YUyM2c17R8YK6YO/qS2UowOVJlx3jZZJi4F7tB5k6o=;
	h=Date:To:From:Subject:Message-Id; b=b1Us1QIfAGZUraHWAIfgkAKaYJWVSKoT4DsEMSCksgQouSEDLpd9gqtQSEojiJjEWaGM+Wf1yBXHnVbfDdUsmulePXlBmA37IkR/oysWlhGFiWAnV/l+b3nspDPZ96kidwOaih2T3BuZoMEfzSbZfHnELF3mevq8tf1vZ6S6z/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l2Jtc9At; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l2Jtc9At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFACC4CEEF;
	Sat,  2 Aug 2025 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161351;
	bh=3YUyM2c17R8YK6YO/qS2UowOVJlx3jZZJi4F7tB5k6o=;
	h=Date:To:From:Subject:From;
	b=l2Jtc9AtjwHsCe1lBITeLGC+qpSDGucKMhy53vYhxmIAtN1h01S4OAQW3TM6kUV+7
	 QhRVuu8BZaobQUWqcmCKNlMFQypmEH4kP7wBQd+l9uzvmnkMW2uHR3oWOMwXPagbEb
	 nemJaLUvCOnRr2LdyODMtp+LdqiMgsdbXbDYs17g=
Date: Sat, 02 Aug 2025 12:02:30 -0700
To: mm-commits@vger.kernel.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] samples-kconfig-fix-spelling-mistake-instancess-instances.patch removed from -mm tree
Message-Id: <20250802190231.4DFACC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples: Kconfig: fix spelling mistake "instancess" -> "instances"
has been removed from the -mm tree.  Its filename was
     samples-kconfig-fix-spelling-mistake-instancess-instances.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: samples: Kconfig: fix spelling mistake "instancess" -> "instances"
Date: Thu, 24 Jul 2025 12:17:15 +0100

There is a spelling mistake in the SAMPLE_TRACE_ARRAY config. Fix it.

Link: https://lkml.kernel.org/r/20250724111715.141826-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/Kconfig~samples-kconfig-fix-spelling-mistake-instancess-instances
+++ a/samples/Kconfig
@@ -54,7 +54,7 @@ config SAMPLE_FTRACE_OPS
 	  measures the time taken to invoke one function a number of times.
 
 config SAMPLE_TRACE_ARRAY
-        tristate "Build sample module for kernel access to Ftrace instancess"
+        tristate "Build sample module for kernel access to Ftrace instances"
 	depends on EVENT_TRACING && m
 	help
 	 This builds a module that demonstrates the use of various APIs to
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


