Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035E1126C03
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 13:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952468; cv=none; b=dTmbQSY+HriwL8/GcopcplJ/v2JGgqxnS648gb5QbdjaE1ONCr25wx1C8Y1UaQXnZ8BtK0xKgVDcNMhZfg7KcchQP7oAa7Bms4uZBqeRrH1P/nV31iDi1tnRcUDg45nw4AtDgf8dtJU+6TbrBsAfESNMLbI7dmvcoO1z0saF2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952468; c=relaxed/simple;
	bh=HwCkiRh/pL7R/RBhusQe2o0QxVeUKyFle72CWcgXQRY=;
	h=Date:To:From:Subject:Message-Id; b=JxtxlrBG3UXhLJhS87JEm9cV0i6aqAZh/84COEjW9g7x86BG5WYmLT9yZTaUZT6OZVjWbe97m3LKZVl+jNADaO4DZdzDHIKUBW442Y/x1Z+LW3j8bWE9rHFgn41KMYouXakbiiWeL6a1KUf8wkmm7Nt9uMEf7TfX6QdDnvG/S0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H5IyO6GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H5IyO6GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E87DC2BCB3;
	Thu, 23 Apr 2026 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776952467;
	bh=HwCkiRh/pL7R/RBhusQe2o0QxVeUKyFle72CWcgXQRY=;
	h=Date:To:From:Subject:From;
	b=H5IyO6GNFYJk7LUC+vMIF6HmpgP2WqyspRpCpcivGNwL4aXBD01cF4V0sSEDnfpx6
	 D2e+IXr2DuZLW1CnguPypdggkkmksphV7IXX1E3DSX1BKOdimHHNbNuOCo6WyJ9zeg
	 DBUyvvns3sC2GcpquEh/zrcEZ228HKPjwmhV6QpQ=
Date: Thu, 23 Apr 2026 06:54:26 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-rewrite-next_tgid-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260423135427.7E87DC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc-rewrite-next_tgid-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-rewrite-next_tgid-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-rewrite-next_tgid-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-rewrite-next_tgid-fix
Date: Thu Apr 23 06:52:34 AM PDT 2026

remove newline

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/proc/base.c~proc-rewrite-next_tgid-fix
+++ a/fs/proc/base.c
@@ -3546,8 +3546,7 @@ struct tgid_iter {
 	struct pid_namespace *const pid_ns;
 };
 
-static
-struct tgid_iter
+static struct tgid_iter
 make_tgid_iter(unsigned int init_tgid, struct pid_namespace *pid_ns)
 {
 	return (struct tgid_iter){
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-rewrite-next_tgid-fix.patch

