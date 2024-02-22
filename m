Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF5C17C79
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645171; cv=none; b=J3btYtCYsiabUdhNpZ4wG9FZ00eyJpxFKfyBK9hywBg8xYdreZI+R3OFT5SIciO2hekFOZA7Mm6NdCRMxD5Hnj00GtWbxSl81hqWS/H73WC8l1oMVxkU77GXUb/WEcrhU4WsuqTqEQ+e1u5D3sjZhYl6/VDKOdztPY5CGz2JzXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645171; c=relaxed/simple;
	bh=nT4AwLtMWh+gyr+noRatDDGdSB+P0ZNQwBAvVhOXdps=;
	h=Date:To:From:Subject:Message-Id; b=ftiS9pykn8UTW7FUu0C0GIy9gcXJkFbuqVWv9EVV+WYVVcV+UcPPTY/Bgz0NtUl4nHhtuIhSBT27YLS1qyVBIJstGrqexpwNnAxnDxhwhYURF1k7mzIpG/sRHo6EzRdoubEOpkrtvdh7pNkFpua/f9irL49YqLaMXopDJOS0bHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fA3+z9Rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fA3+z9Rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A354EC433F1;
	Thu, 22 Feb 2024 23:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645170;
	bh=nT4AwLtMWh+gyr+noRatDDGdSB+P0ZNQwBAvVhOXdps=;
	h=Date:To:From:Subject:From;
	b=fA3+z9RjymCNWqAzUrtSpgfV8QMcze6Vt8TRypAP01B/bJZe2KloNCOkzNhdCFVQb
	 ZYj+Vgw87SZNjEyRXMQ72LhpcTz3AUZm5Q/UGN3MwAQrHE2HwVklMxb0dlsxQRMczl
	 CfiCdtB8oCEbgRJNTH1kVChjunvoIhaqDvghwFnY=
Date: Thu, 22 Feb 2024 15:39:30 -0800
To: mm-commits@vger.kernel.org,tkjos@android.com,surenb@google.com,mingo@kernel.org,maco@android.com,kent.overstreet@gmail.com,keescook@chromium.org,joel@joelfernandes.org,jani.nikula@intel.com,gregkh@linuxfoundation.org,elver@google.com,colyli@suse.de,cmllamas@google.com,brauner@kernel.org,arve@android.com,andriy.shevchenko@linux.intel.com,pierre.gondois@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] binder-use-of-hlist_count_nodes.patch removed from -mm tree
Message-Id: <20240222233930.A354EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: binder: use of hlist_count_nodes()
has been removed from the -mm tree.  Its filename was
     binder-use-of-hlist_count_nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pierre Gondois <pierre.gondois@arm.com>
Subject: binder: use of hlist_count_nodes()
Date: Thu, 4 Jan 2024 17:49:34 +0100

Make use of the newly added hlist_count_nodes().

Link: https://lkml.kernel.org/r/20240104164937.424320-3-pierre.gondois@arm.com
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Coly Li <colyli@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Martijn Coenen <maco@android.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/android/binder.c~binder-use-of-hlist_count_nodes
+++ a/drivers/android/binder.c
@@ -6086,9 +6086,7 @@ static void print_binder_node_nilocked(s
 	struct binder_work *w;
 	int count;
 
-	count = 0;
-	hlist_for_each_entry(ref, &node->refs, node_entry)
-		count++;
+	count = hlist_count_nodes(&node->refs);
 
 	seq_printf(m, "  node %d: u%016llx c%016llx hs %d hw %d ls %d lw %d is %d iw %d tr %d",
 		   node->debug_id, (u64)node->ptr, (u64)node->cookie,
_

Patches currently in -mm which might be from pierre.gondois@arm.com are


