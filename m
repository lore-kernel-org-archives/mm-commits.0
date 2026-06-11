Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5BB4D2ECB
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781203386; cv=none; b=nbOOasnzQdWSsi6tidgTMr4be++R0l9BDS20FjtpENqTgLYvCXWJ6sfEhDs3HZQmhd6QAdlkpFdvR1Ns2+pQxYah2kaQ232JLGzy5G5V9GSJ3L47NeqIorsXrHa4GOLbvUwTV4omoxznt6ea6+csTMrR2pAkus33OBINGT57xuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781203386; c=relaxed/simple;
	bh=VTc1np+v8Adb84sPl6rVEJWvDvmFrhkbWN4UqH+y9b8=;
	h=Date:To:From:Subject:Message-Id; b=WlLH8Aml6Lp9XDhtcv8qDZo8rx/hzzKnTf2kUKr/djFJQLbIMOt7jiD2wIGHFn7VbmFRqrRxHWD2VwgBkJyauRjLGIendQvZ2ldjoiFK3UtDo8rY+HHFMahcLnkOUEKR9BvKsQSqHHzj5EzrE+Xm5BbzaJi0tGEWf6c3mfVsxEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQpjJgAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQpjJgAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7DE1F00A3A;
	Thu, 11 Jun 2026 18:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781203384;
	bh=XC8aonWnDdXo4EwXt+lw/CqSU7DPemDp/hDs805f5bc=;
	h=Date:To:From:Subject;
	b=UQpjJgAV6HdghddQNQh66edgA1uxjUSkJkakU41bfu1FTBpWjQMLM1sv82dAaITO4
	 H60Pr56hMhVXJKlPtse/itkgf6HG8pfWADli84sGKuHkz1xPh9AJhHNkzkxj8sAPU8
	 kf7DLNW3ywkknwsZlyXM5AnP4FZZ1OkeQHVf0WLg=
Date: Thu, 11 Jun 2026 11:43:04 -0700
To: mm-commits@vger.kernel.org,scott.branden@broadcom.com,mcgrof@kernel.org,kees@kernel.org,akpm@linux-foundation.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_firmware-allocate-the-configured-into_buf-size.patch removed from -mm tree
Message-Id: <20260611184304.8C7DE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_firmware: allocate the configured into_buf size
has been removed from the -mm tree.  Its filename was
     lib-test_firmware-allocate-the-configured-into_buf-size.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Moelius <sam.moelius@trailofbits.com>
Subject: lib/test_firmware: allocate the configured into_buf size
Date: Fri, 5 Jun 2026 00:30:37 +0000

The batched into_buf test path allocates TEST_FIRMWARE_BUF_SIZE bytes
unconditionally, but then passes test_fw_config->buf_size to
request_firmware_into_buf() or request_partial_firmware_into_buf().

Userspace can set config_buf_size above TEST_FIRMWARE_BUF_SIZE before
triggering a batched request. If the firmware file is large enough, the
firmware loader writes past the end of the 1 KiB test buffer.

Allocate the buffer with the same size that the test passes to the firmware
API so config_buf_size remains the actual buffer size under test.

Assisted-by: Codex:gpt-5.5-cyber-preview
Link: https://lore.kernel.org/20260605003038.2005840-1-sam.moelius@trailofbits.com
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_firmware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_firmware.c~lib-test_firmware-allocate-the-configured-into_buf-size
+++ a/lib/test_firmware.c
@@ -867,7 +867,7 @@ static int test_fw_run_batch_request(voi
 	if (test_fw_config->into_buf) {
 		void *test_buf;
 
-		test_buf = kzalloc(TEST_FIRMWARE_BUF_SIZE, GFP_KERNEL);
+		test_buf = kzalloc(test_fw_config->buf_size, GFP_KERNEL);
 		if (!test_buf)
 			return -ENOMEM;
 
_

Patches currently in -mm which might be from sam.moelius@trailofbits.com are

mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch
mm-gup_test-reject-wrapped-user-ranges.patch
lib-interval_tree_test-validate-benchmark-parameters.patch
fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors.patch

