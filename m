Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35A3145344
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293197; cv=none; b=hj7RSEoK0JXfbItzeQIaJzS3zLhB9LVPFKBcrXO8rmp7b6SFWl7E8uI2jq1ieB11Pt+piO3hlzqfmAB83Dbg8uNqiDF4ilaFMuv1NuxRP8xM0mP+4LPQCyv3jquRvYNOrSCqtAQ7TcnlylgAGGU5pn8JhhFA9ec77l7kiZk9tKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293197; c=relaxed/simple;
	bh=ZeigcJfkbTdFHx1UktvL9zhqWMvTaVKg6skI3JBTow8=;
	h=Date:To:From:Subject:Message-Id; b=FlK1puROfze78blTjsaJOq5ldJnBfDF2cwx7rLsVp4oQhjYOl9maCvCKydiXWLwqbjLkdBgrlSWQUfF3y3xg+rIy4Kq0D5No3OtWWAlpt1MVMFB4BxWaAzP+xK7V0TivpxFtYLSHxMG26yyNRydw4de9ujAslKMMkURihj1SwbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VZvqLjhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VZvqLjhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A787CC32782;
	Tue, 25 Jun 2024 05:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293197;
	bh=ZeigcJfkbTdFHx1UktvL9zhqWMvTaVKg6skI3JBTow8=;
	h=Date:To:From:Subject:From;
	b=VZvqLjhgGZilicYjtauZdy8d+VToORyuZP/wpCnxoaIaU8FnzBrsssTiIPmOvrZnE
	 bqBJJ93Dg6ZNbFAuYC1hMK3TfRveVuHgVe9tqfaD4kyDnFCNhHy95pU2e0MQpQiMfH
	 /wcKSKwmIBKM8QijEXyN2LYNx82+k9euDVpsy9Tc=
Date: Mon, 24 Jun 2024 22:26:37 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-panic-return-early-from-print_tainted-when-not-tainted.patch removed from -mm tree
Message-Id: <20240625052637.A787CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic: return early from print_tainted() when not tainted
has been removed from the -mm tree.  Its filename was
     kernel-panic-return-early-from-print_tainted-when-not-tainted.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: kernel/panic: return early from print_tainted() when not tainted
Date: Fri, 31 May 2024 12:04:54 +0300

Reduce indent to make follow-up changes slightly easier on the eyes.

Link: https://lkml.kernel.org/r/01d6c03de1c9d1b52b59c652a3704a0a9886ed63.1717146197.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/kernel/panic.c~kernel-panic-return-early-from-print_tainted-when-not-tainted
+++ a/kernel/panic.c
@@ -507,22 +507,23 @@ const struct taint_flag taint_flags[TAIN
 const char *print_tainted(void)
 {
 	static char buf[TAINT_FLAGS_COUNT + sizeof("Tainted: ")];
+	char *s;
+	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
 
-	if (tainted_mask) {
-		char *s;
-		int i;
-
-		s = buf + sprintf(buf, "Tainted: ");
-		for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
-			const struct taint_flag *t = &taint_flags[i];
-			*s++ = test_bit(i, &tainted_mask) ?
-					t->c_true : t->c_false;
-		}
-		*s = 0;
-	} else
+	if (!tainted_mask) {
 		snprintf(buf, sizeof(buf), "Not tainted");
+		return buf;
+	}
+
+	s = buf + sprintf(buf, "Tainted: ");
+	for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
+		const struct taint_flag *t = &taint_flags[i];
+		*s++ = test_bit(i, &tainted_mask) ?
+			t->c_true : t->c_false;
+	}
+	*s = 0;
 
 	return buf;
 }
_

Patches currently in -mm which might be from jani.nikula@intel.com are


