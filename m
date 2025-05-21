Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BF227C14E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849752; cv=none; b=Jj6eyedwSW1tJCHYrGl217LnoXXANAOnLKJwlZ234xkX/aj7VJn8+SqhQqkBiCuKSFJAzdcDatfkmAti5fAe11W2iJN3cw9VX5+Rx+Q4rRijam1YoIzowpoVXS3+n5Pql1FCLtPrmd7WD4wkDP9vfDd+BI+nVc2wOdH1EtYvwsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849752; c=relaxed/simple;
	bh=qKKRdLSA0RfUESzcPAPR5jT63q5ytvv9EdNVbwnrno8=;
	h=Date:To:From:Subject:Message-Id; b=EJv2dvw+sHT92CW0Hih3kD7IpOxsyTCh+YPltDMnDAZTJo28joKfFAPu9tjCdl4SNVLNCaHYvf8VJB+VLyZvKmq1BkJNVrtwDJolqzVuHVozVtWl0kewCJotH+/O4umYl7sbwQ/2sSWEx4hMru9cEyllLA0egmbU9NmbUEZ6zN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JJQsWgm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JJQsWgm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BB5C4CEE4;
	Wed, 21 May 2025 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849752;
	bh=qKKRdLSA0RfUESzcPAPR5jT63q5ytvv9EdNVbwnrno8=;
	h=Date:To:From:Subject:From;
	b=JJQsWgm/T2HIkxIeve1m+xcaYxw7lmHB7CRwryeOV7tYJ4MrNcAbAUM9JQV3U/7YT
	 LE46A1bGxIzKezNE5K8slWXmlQKKe7uHzi7OZaU+X3G7HEaGIndQxG8qlwCWy5e12w
	 qjzMuO0BcSUDGxLQe1sbWnOrxuGvpCssQY3yuJiM=
Date: Wed, 21 May 2025 10:49:11 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,pmladek@suse.com,john.ogness@linutronix.de,jani.nikula@intel.com,gregkh@linuxfoundation.org,sravankumarlpu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-format-kernel-doc-comments.patch removed from -mm tree
Message-Id: <20250521174911.F1BB5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic.c: format kernel-doc comments
has been removed from the -mm tree.  Its filename was
     kernel-format-kernel-doc-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sravan Kumar Gundu <sravankumarlpu@gmail.com>
Subject: kernel/panic.c: format kernel-doc comments
Date: Fri, 16 May 2025 17:40:31 +0000

kernel-doc function comment don't follows documentation commenting style
misinterpreting arguments description with function description.

Please see latest docs generated before applying this patch
https://docs.kernel.org/driver-api/basics.html#c.panic

Link: https://lkml.kernel.org/r/20250516174031.2937-1-sravankumarlpu@gmail.com
Signed-off-by: Sravan Kumar Gundu <sravankumarlpu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/panic.c~kernel-format-kernel-doc-comments
+++ a/kernel/panic.c
@@ -277,12 +277,10 @@ static void panic_other_cpus_shutdown(bo
 }
 
 /**
- *	panic - halt the system
- *	@fmt: The text string to print
+ * panic - halt the system
+ * @fmt: The text string to print
  *
- *	Display a message, then perform cleanups.
- *
- *	This function never returns.
+ * Display a message, then perform cleanups. This function never returns.
  */
 void panic(const char *fmt, ...)
 {
_

Patches currently in -mm which might be from sravankumarlpu@gmail.com are


