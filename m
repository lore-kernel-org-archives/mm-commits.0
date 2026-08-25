Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3260367B60
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622907; cv=none; b=icbiX3GD1TrWwOmYtBNFXbjFN0MZMMc6MrHTiYtmW2GZ4b/eCSeB24W1FFLSkjo+wu9GiXHOeH0HsZDaa5RAWK3UdeNSqw6VG5uzK7KVHLbsFWwU21mRVRgcJO09J4pTV2Xy4YhUthmPtuf58l214S2TRigVwMxySlPiXjF2yNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622907; c=relaxed/simple;
	bh=Ib8S9OvWI4Tew4TOcotsKUkDkRw/531iaCNtg2ifEbA=;
	h=Date:To:From:Subject:Message-Id; b=Ta5n4kX3SzSBp+zILfHr5fiNikaKO3+EOuXNduvzgWL513EXFr6TBuhmeT96E/QjnP+HJf1XOGUXGJ0yFSTRCQ307nZBe2N5Qat/G17cGo+xJCaaoL///FuXrKOLag8CWBGyZrKgD3S0Nvgo5SauQTuuqe3ZobQlI69q2SPypOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQlF4a94; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQlF4a94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99391F00A3A;
	Tue, 25 Aug 2026 01:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622905;
	bh=1fsjFl3n2cj5OrVmODp/j/5lxaJkDbQ7LAOn1hF7+Cs=;
	h=Date:To:From:Subject;
	b=qQlF4a949v5tXZw5o6aeUTE0GzmCZ7BoEXVfgMiUX7M9K/c/iiFKArDGaoCRjeCr0
	 Xuay8sR/HcCpu3Isgxjce2S0i/8Kk+C8c68fY/qFHXd0ra/rbrZFC1VuNFpUJyqFSJ
	 RM6nefnQbk06dZX/kUVNS3nKXHPfW+Ki8K/++I9Y=
Date: Mon, 24 Aug 2026 18:55:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,geert@linux-m68k.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-factor-leak-confirmation-into-a-helper.patch removed from -mm tree
Message-Id: <20260825015505.B99391F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: factor leak confirmation into a helper
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-factor-leak-confirmation-into-a-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: factor leak confirmation into a helper
Date: Mon, 13 Jul 2026 04:48:06 -0700

The reporting loop in kmemleak_scan() decided whether to tag an object as
a reported leak with a four-term compound condition whose last operand
also had a side effect (++object->unref_scans).  Mixing the candidate
tests with the counter update made the check hard to read.

Move the state transition into confirm_leak(): it returns true when a
still-unreferenced suspect crosses min_unref_scans consecutive scans and
is newly flagged OBJECT_REPORTED, leaving only the reporting bookkeeping
in the caller.  No functional change.

Link: https://lore.kernel.org/20260713-catalin_pto-v1-3-5b93b1131089@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-factor-leak-confirmation-into-a-helper
+++ a/mm/kmemleak.c
@@ -2015,6 +2015,26 @@ scan_gray:
 }
 
 /*
+ * Promote a suspected object to a reported leak once it has stayed
+ * unreferenced for min_unref_scans consecutive scans. Called with
+ * object->lock held; returns true when the object is newly reported.
+ */
+static bool confirm_leak(struct kmemleak_object *object)
+{
+	if (!unreferenced_object(object) ||
+	    !(object->flags & OBJECT_SUSPECT) ||
+	    (object->flags & OBJECT_REPORTED))
+		return false;
+
+	object->unref_scans += 1;
+	if (object->unref_scans < min_unref_scans)
+		return false;
+
+	object->flags |= OBJECT_REPORTED;
+	return true;
+}
+
+/*
  * Scan the memory and report the unreferenced objects as leaks. Must be
  * called with the scan_mutex held.
  */
@@ -2074,11 +2094,7 @@ static void kmemleak_scan(void)
 		trace_handle = 0;
 		dedup_print = false;
 
-		if (unreferenced_object(object) &&
-		    (object->flags & OBJECT_SUSPECT) &&
-		    !(object->flags & OBJECT_REPORTED) &&
-		    ++object->unref_scans >= min_unref_scans) {
-			object->flags |= OBJECT_REPORTED;
+		if (confirm_leak(object)) {
 			if (kmemleak_verbose) {
 				trace_handle = object->trace_handle;
 				dedup_print = true;
_

Patches currently in -mm which might be from leitao@debian.org are


