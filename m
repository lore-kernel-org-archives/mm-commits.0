Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C959618872A
	for <mm-commits@vger.kernel.org>; Wed,  3 Jun 2026 01:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780449578; cv=none; b=XvJxnYllmx3LSQmR8f21OrTNXTX0VKcRpTqglSNSzZ+R63qIpWICqZ/rKzUWYNs5uXkD9RT13EMzIFllm3MC44w/ROGVgFqpw0p3ZdNqn+WC3Wh2vwHRuYHVXK4E3xUzF12qWx2igbVDfyG96OIcYMMOqbkJkJWSPRadat7U4Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780449578; c=relaxed/simple;
	bh=8z5aLYYQ4K6Dj4XTfaJVs4d7+o7GUz3zhxWh1HKa5Z0=;
	h=Date:To:From:Subject:Message-Id; b=HsxhtRvPi6MBMrUhJCN94H52bA8q/I3LCfLV0LbctOpkZ5jCpijbK2N6ILrTeQ0hfDlH//v2v8hxrujtGmD+pa6b8Yzt7qcp1SK9kXe+2FfPJ93NK0AV/cJnl2LEkWT5Qb9v+5+YNFFBiRt3pGA0jxTs8pC8/t5NpcF4gngHlJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wD2YbDMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wD2YbDMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2111F00893;
	Wed,  3 Jun 2026 01:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780449577;
	bh=RYJ49BE6UDyEfq+MU+TYB+8DFosCfeyhobcID3spDak=;
	h=Date:To:From:Subject;
	b=wD2YbDMjSfwCYETqEG2EBwSk695hPhBtCQTha905XyFmWSaWvKdjWASsDwD+62dNs
	 jefbC3TkCJ9EfmMtw/mjytlSdChrNpEkE7SZhcp6WWNmzll/j94hCZtb8Uwh6fFgpo
	 vxHHcNxBYJSwYVjcSfdx38VSxr2sk0jzTAYZ6lik=
Date: Tue, 02 Jun 2026 18:19:36 -0700
To: mm-commits@vger.kernel.org,devnexen@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20260603011937.4B2111F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes
Date: Fri May  1 06:17:38 AM PDT 2026

WARNING: Unknown commit id '8e6e0d845823', maybe rebased or not pulled?
#28: 
Fixes: 8e6e0d845823 ("mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device")

WARNING: Assisted-by expects 'AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]' format
#29: 
Assisted-by: Codex (gpt-5-codex)

ERROR: code indent should use tabs where possible
#54: FILE: include/linux/swap.h:440:
+                                       sector_t offset);$

WARNING: please, no spaces at the start of a line
#54: FILE: include/linux/swap.h:440:
+                                       sector_t offset);$

total: 1 errors, 3 warnings, 106 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Carlier <devnexen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes
+++ a/include/linux/swap.h
@@ -436,7 +436,7 @@ extern void si_swapinfo(struct sysinfo *
 extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
 extern void unpin_hibernation_swap_type(int type);
 extern int repin_hibernation_swap_type(int old_type, dev_t device,
-                                       sector_t offset);
+				       sector_t offset);
 extern int find_hibernation_swap_type(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

