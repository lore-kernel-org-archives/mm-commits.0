Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CADA2E7F39
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298534; cv=none; b=D51Sm4DPHN27ovGpQ2rbnmHQN/qatUsnpLgM5S8c1+DCRfN27L4h59bWYiTVXbboPUCIyB7HxoqcSrOJWnLd6gTfhUaY2T9v0VJ5KFaEUrbkKNVJQcEo7+ySQHwc10+vamWlPlsSv/fx6OielDVJaSnNYS7p2TpJnAudGwTPIm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298534; c=relaxed/simple;
	bh=yl/LZ2ca1XOyvg5dlN7uxUCE55sxySUzdYgV0gzKERU=;
	h=Date:To:From:Subject:Message-Id; b=X1ZidSPPzisUJ0UeS3vvJ5RPAvIjdu8DWIJ3ZFQu+w0jcWCdXsO0RIT3mbPv4BGHchJ4c7Pv0I6ZAthHPagrb1THe3ScFQ3zrl1KNCBT0d8MK9dKc1D8sKY9sy5U9529Ot/iQ6UqbOoCzPRp5HY90IUa5Z9QTcIP/0hpupURKtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PWCEz1tO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PWCEz1tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606B81F00A3A;
	Wed, 29 Jul 2026 04:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298532;
	bh=3XtVqCfwXd2c46C0mv16IJvswuY8JR3dR3vdXCsMbGk=;
	h=Date:To:From:Subject;
	b=PWCEz1tOPrwQ08npeWSSFWq8WPn3S8HLGKzWg49oKbfBPGG21Ii7ErswmKD9gEkua
	 tUc17p6ZyxJTeM5MDNHkxY13pLJeL6siGm/N0EBjU+ux7eUlHfFpfcNUwr/9luqDm6
	 79wKqO08rGbTl72OZPvFp0ZvN1QVgb3b40TnwPbI=
Date: Tue, 28 Jul 2026 21:15:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,chentao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-prevent-cross-context-state-pollution-in-damonctx.patch removed from -mm tree
Message-Id: <20260729041532.606B81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: prevent cross-context state pollution in DamonCtx
has been removed from the -mm tree.  Its filename was
     selftests-damon-prevent-cross-context-state-pollution-in-damonctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kunwu Chan <chentao@kylinos.cn>
Subject: selftests/damon: prevent cross-context state pollution in DamonCtx
Date: Mon, 29 Jun 2026 07:46:44 -0700

Patch series "selftests/damon: misc fixes for test bugs", v3.

This series fixes several bugs in the DAMON selftests.  Most are trivial
but makes test output wrong or even silently pass the one test case for
'avail_operation' file existence check.

Patch 1 fixes mutable default arguments in DamonCtx.__init__() that cause
state to leak between test instances.

Patch 2 fixes wrong operator precedence and join TypeError in
damos_tried_regions.py.

Patch 3 fixes several wrong strings that produce dead elif branches,
skipped file existence checks, and broken dict key lookups.


This patch (of 3):

DamonCtx.__init__() uses mutable default values for monitoring_attrs,
targets, and schemes.  In Python these are evaluated once at function
definition time, so multiple DamonCtx instances can unintentionally share
the same lists and DamonAttrs instance.

Replace the mutable defaults with None sentinels and initialize the
objects when needed.

Link: https://lore.kernel.org/20260629144648.134092-1-sj@kernel.org
Link: https://lore.kernel.org/20260601032314.424013-2-kunwu.chan@linux.dev
Link: https://lore.kernel.org/20260629144648.134092-2-sj@kernel.org
Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-prevent-cross-context-state-pollution-in-damonctx
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -624,17 +624,23 @@ class DamonCtx:
     pause = None
     idx = None
 
-    def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[], pause=False):
+    def __init__(self, ops='paddr', monitoring_attrs=None, targets=None,
+            schemes=None, pause=False):
         self.ops = ops
+        if monitoring_attrs is None:
+            monitoring_attrs = DamonAttrs()
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
 
+        if targets is None:
+            targets = []
         self.targets = targets
         for idx, target in enumerate(self.targets):
             target.idx = idx
             target.context = self
 
+        if schemes is None:
+            schemes = []
         self.schemes = schemes
         for idx, scheme in enumerate(self.schemes):
             scheme.idx = idx
_

Patches currently in -mm which might be from chentao@kylinos.cn are


