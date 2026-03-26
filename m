Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC8FA92E
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 03:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774497259; cv=none; b=q66PsYx+l7w4pH35fZ2EP6mbHgNRuDIk2ASJVCvKuAmx1gTxlnE6lbZNSPLOBFr2GQ3XrYDBYGhoNhqncUkjWkiGAjTz8xpwhx2bVcBLtzatyrM9pOE8unrNiUx2spWeX+cr8V4qD/IqaC9qHRV66I+a5c5yFMzwNJZNU0d8nuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774497259; c=relaxed/simple;
	bh=Lrog+Uq8jwEQZv07c+RB5cx3LOGIu2FH1/Z/yIxV6u0=;
	h=Date:To:From:Subject:Message-Id; b=Cbc5FJ2UD3+8Nd9NfuQ5FIUAdza+Y9D7T60uQffy/t0Dx9cQHP+RNMKa+6Wfx87XNx5QfAeDDForWr39H6pi0ReuMhGe9bSoBQ80aW8zSfDP9wtaji+vIr+KNZJnbh25dPMpv4YZw21IJOwPW49WlKB/6YMSWaSqI4bIU1i1PpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M3aHD6Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M3aHD6Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CF2C19424;
	Thu, 26 Mar 2026 03:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774497258;
	bh=Lrog+Uq8jwEQZv07c+RB5cx3LOGIu2FH1/Z/yIxV6u0=;
	h=Date:To:From:Subject:From;
	b=M3aHD6SdF76hRUvcmGrIOZNOw98JSzKHGONOA7wcoh6K07mLX1Elh95S0DWHJAKXb
	 KDl7ocfMMiQ4ozK9Z3GkMKDhbNpQxJ0Izb8+K9lJQ3tZcPfXAXCqCKw83qr83kDBQR
	 SDUGKvgusUxGYfCc/MubvpmMEAy+aru5i5s2Ts/4=
Date: Wed, 25 Mar 2026 20:54:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,leotimmins1974@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-initialize-incoming-flb-state-before-finish.patch added to mm-hotfixes-unstable branch
Message-Id: <20260326035418.D2CF2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: initialize incoming FLB state before finish
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     liveupdate-initialize-incoming-flb-state-before-finish.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-initialize-incoming-flb-state-before-finish.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Leo Timmins <leotimmins1974@gmail.com>
Subject: liveupdate: initialize incoming FLB state before finish
Date: Wed, 25 Mar 2026 12:46:08 +0800

luo_flb_file_finish_one() decremented incoming.count before making sure
that the incoming FLB state had been materialized.  If no earlier incoming
retrieval had populated that state, the first decrement ran from zero and
skipped the last-user finish path.

Initialize the incoming FLB state before the first decrement so finish
uses the serialized refcount instead of an uninitialized value.

Link: https://lkml.kernel.org/r/20260325044608.8407-3-leotimmins1974@gmail.com
Fixes: cab056f2aae7 ("liveupdate: luo_flb: introduce File-Lifecycle-Bound global state")
Signed-off-by: Leo Timmins <leotimmins1974@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-initialize-incoming-flb-state-before-finish
+++ a/kernel/liveupdate/luo_flb.c
@@ -192,10 +192,27 @@ static int luo_flb_retrieve_one(struct l
 static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
+	bool needs_retrieve = false;
 	u64 count;
 
-	scoped_guard(mutex, &private->incoming.lock)
+	scoped_guard(mutex, &private->incoming.lock) {
+		if (!private->incoming.count && !private->incoming.finished)
+			needs_retrieve = true;
+	}
+
+	if (needs_retrieve) {
+		int err = luo_flb_retrieve_one(flb);
+
+		if (err) {
+			pr_warn("Failed to retrieve FLB '%s' during finish: %pe\n",
+				flb->compatible, ERR_PTR(err));
+			return;
+		}
+	}
+
+	scoped_guard(mutex, &private->incoming.lock) {
 		count = --private->incoming.count;
+	}
 
 	if (!count) {
 		struct liveupdate_flb_op_args args = {0};
_

Patches currently in -mm which might be from leotimmins1974@gmail.com are

liveupdate-propagate-file-deserialization-failures.patch
liveupdate-initialize-incoming-flb-state-before-finish.patch

