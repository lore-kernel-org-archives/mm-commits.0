Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDEF3FCC;
	Thu, 10 Sep 2026 04:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789014597; cv=none; b=nl9is38Q2792DnNc5Cvj1x/I1R3nf+O8jnzG2InLODEMzZGVn+yjlQWNTdX53arpUgWvq0h75NBwlnmcJ0K9IbiRkXvGDPQGu1VQey6wrUR8UK55JmcdyQRh2qoSWaExMYAUwzjwOYAN0xtoNqzCklvwoqOFwxPtAbhDuYIr4gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789014597; c=relaxed/simple;
	bh=yZT+94phn7uBo4mPCea8ymP+tZKFTolTIrPIp3UH1C0=;
	h=Date:To:From:Subject:Message-Id; b=UP15Qvbh9u9w1bOkvQylUILIIFxL8FbjI+ZbtaYc9YdoWXwcw9kz8IADRkf9NnyJh7D7+oM7h0rTDH/iuJz4iWmFGsdbislAKrjHq0vBZe3zlBgO7fOEh1L+9E2vPMYGEjeonsy5Mt6o7Lw7aSZFOtRW2tlDEABoOAtM2SV3VkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DbRdZnXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DbRdZnXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F851F000FF;
	Thu, 10 Sep 2026 04:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789014596;
	bh=M+gUV3felxceZ+qv9bbKRNMi9bH5+CCnQVJBAqlwk4s=;
	h=Date:To:From:Subject;
	b=DbRdZnXt1sbmRJtGHiAdB6fpMktTFEzyz4yjc2FVgCzeALSMZX4cDGOnctKJxX6hz
	 TtfjUlFgbQKZvPLg3o9kuQIyYJWN+ljuT+vC2JgP7QtNoErkURGdjXMr0zjQqKdIP3
	 kRZ2XBU82tNtrIhp0xOCFEJxwOXeScC+X47YDahw=
Date: Wed, 09 Sep 2026 21:29:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tools-bootconfig-fix-integer-overflow-in-size-check.patch removed from -mm tree
Message-Id: <20260910042955.E9F851F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/bootconfig: Fix integer overflow in size check
has been removed from the -mm tree.  Its filename was
     tools-bootconfig-fix-integer-overflow-in-size-check.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: tools/bootconfig: Fix integer overflow in size check
Date: Thu, 10 Sep 2026 09:30:46 +0900

Sashiko reported that on 32-bit systems, if the size in the bootconfig
footer is corrupted such that adding BOOTCONFIG_FOOTER_SIZE wraps around
(for instance, if size is 0xFFFFFFFF), the size check in
load_xbc_from_initrd() can be bypassed:

    if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
        pr_err("bootconfig size is too big\n");
        return -E2BIG;
    }

This would lead to load_xbc_fd() being called with a negative size,
resulting in an undersized allocation, heap overflow on read, and
out-of-bounds write on the terminating null byte.

Avoid the integer overflow by checking whether size is greater than
stat.st_size - BOOTCONFIG_FOOTER_SIZE.  Since stat.st_size is already
verified to be at least BOOTCONFIG_FOOTER_SIZE earlier in the function,
this subtraction will never underflow.

Link: https://lore.kernel.org/178900024679.183840.10345859264677533824.stgit@devnote2
Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260909161113.16C691F00A3A@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.8-flash
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/bootconfig/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/bootconfig/main.c~tools-bootconfig-fix-integer-overflow-in-size-check
+++ a/tools/bootconfig/main.c
@@ -218,7 +218,7 @@ static int load_xbc_from_initrd(int fd,
 	csum = le32toh(csum);
 
 	/* Wrong size error  */
-	if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
+	if (size > stat.st_size - BOOTCONFIG_FOOTER_SIZE) {
 		pr_err("bootconfig size is too big\n");
 		return -E2BIG;
 	}
_

Patches currently in -mm which might be from mhiramat@kernel.org are

bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

