Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E801027450
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959967; cv=none; b=iArM10xaWDiuKH37jfONjpdtvxbv+YcdBlMEn3s4u6o+W5ZDo8mCK5dk0ZX/RKYZ/hLFPO8+3NmXjtV/IOzAsTVyGRIBJiFhiXAwDPLfbTze94SaMd6ZUrOzuZzPCZM92Xq2oTXS7Eqy/Qb6AaSyNq8bPlDsdSfqw3Ib8KQlKvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959967; c=relaxed/simple;
	bh=XSi+gVbenTMNMS4qvL0cZgQbHV1oXsjPJo65D4/WCSY=;
	h=Date:To:From:Subject:Message-Id; b=SvtiGY3D0apY6N+UjjOJjDXmkNmYF2+RlKtaMUFX0yQEZajDIaN6V8AxdFSGqdFt+OPY4s7R/sX2m42MPhpm4LyljeA4Wb/lTLlbOZ3P85noezwTvsAgi3HLCLuWQwXcKPA6MrQhWnFC0w/pJozvUNlwfvxDqO+vO9qKNJiX4r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XIujESuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XIujESuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CA3C4CEED;
	Tue, 12 Aug 2025 00:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959966;
	bh=XSi+gVbenTMNMS4qvL0cZgQbHV1oXsjPJo65D4/WCSY=;
	h=Date:To:From:Subject:From;
	b=XIujESuQ+5IMiV9u7oJd2NkfHgPj35xfkqx9af+prmoLAnYgsy/C9uqzxUzDarxW1
	 CjHO4YqVPlcMCdFcj9/FG3nB1ZGvi2KRahRhP/jj9sAWZXtt5eeUD0l18RiAbljyr9
	 IqGFCrYbiFjaMb10z+hUdrSyCWq8IEPECrl3TA5s=
Date: Mon, 11 Aug 2025 17:52:45 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,linux@weissschuh.net,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-allow-scratch-areas-with-zero-size.patch added to mm-new branch
Message-Id: <20250812005246.60CA3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: allow scratch areas with zero size
has been added to the -mm mm-new branch.  Its filename is
     kho-allow-scratch-areas-with-zero-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-allow-scratch-areas-with-zero-size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: allow scratch areas with zero size
Date: Mon, 11 Aug 2025 11:25:08 +0300

Patch series "kho: fixes and cleanups", v3.

These are small KHO and KHO test fixes and cleanups.


This patch (of 3):

Parsing of kho_scratch parameter treats zero size as an invalid value,
although it should be fine for user to request zero sized scratch area for
some types if scratch memory, when for example there is no need to create
scratch area in the low memory.

Treat zero as a valid value for a scratch area size but reject kho_scratch
parameter that defines no scratch memory at all.

Link: https://lkml.kernel.org/r/20250811082510.4154080-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250811082510.4154080-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kho-allow-scratch-areas-with-zero-size
+++ a/kernel/kexec_handover.c
@@ -405,6 +405,7 @@ static int __init kho_parse_scratch_size
 {
 	size_t len;
 	unsigned long sizes[3];
+	size_t total_size = 0;
 	int i;
 
 	if (!p)
@@ -441,11 +442,15 @@ static int __init kho_parse_scratch_size
 		}
 
 		sizes[i] = memparse(p, &endp);
-		if (!sizes[i] || endp == p)
+		if (endp == p)
 			return -EINVAL;
 		p = endp;
+		total_size += sizes[i];
 	}
 
+	if (!total_size)
+		return -EINVAL;
+
 	scratch_size_lowmem = sizes[0];
 	scratch_size_global = sizes[1];
 	scratch_size_pernode = sizes[2];
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch

