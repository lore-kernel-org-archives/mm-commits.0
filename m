Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136F130495
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924950; cv=none; b=rqdTyo03EdCZoS4asDHQ18g78hunFgwBVHmjBsOqTaE/TR3XkaqxMHFCpuz3IqTdvJyg2Ms9TX6Zlmq7uQqOB1eDMjHL0jeN1HL11XMZllHbq54rWsbX15q4ob6aKjOJOlKvl/heWGKEH8HXUJEB1px6edEdu8xTUT5FjEfci4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924950; c=relaxed/simple;
	bh=gOzC3CGY6NEQ3GX/26J/9cbE6VJjfHTqr+WeT7Zbn50=;
	h=Date:To:From:Subject:Message-Id; b=BQvIlc8LHft8w6Ep4JrZTQpA/I+yrAAGG10rI1D6GqXEzAYeXDbGYsqm924aIaKw/YO3O9Ry2pR7F1a2rpc2crqqPqzNavIk7ufBZdkGhbCVjIcVAOjPH9rAgyhJUCiceTjKNlc6QB5yq5H+WEzP7r45onxzBwm4XOTSwOshd04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nZyGbitI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nZyGbitI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0A3C4CEC5;
	Mon,  9 Sep 2024 23:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924950;
	bh=gOzC3CGY6NEQ3GX/26J/9cbE6VJjfHTqr+WeT7Zbn50=;
	h=Date:To:From:Subject:From;
	b=nZyGbitII8DGlr6jh0mr0/1M040+uhkfHEVZqvhGjvTrodE0fyg2h2ULOzJgwBBze
	 03PBeAmlDsYSuihUXFITT8HHycMK7MFa05wb+v7Ml4jWl1hMBGvqPIplMf+8qqNXJ/
	 O2/qFw01ky7A+8oB4lcZyXZfwhiPwzOxcn3JlV/Y=
Date: Mon, 09 Sep 2024 16:35:49 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,peterz@infradead.org,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] uprobes-use-vm_special_mapping-close-functionality-fix.patch removed from -mm tree
Message-Id: <20240909233550.0B0A3C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uprobes: remove unneeded condition
has been removed from the -mm tree.  Its filename was
     uprobes-use-vm_special_mapping-close-functionality-fix.patch

This patch was dropped because it was folded into uprobes-use-vm_special_mapping-close-functionality.patch

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: uprobes: remove unneeded condition
Date: Fri, 6 Sep 2024 15:18:25 +0500

The area cannot be NULL as we are getting it through container_of(). 
Hence there is no need to check its validity.  Remove the if condition and
return statement.

Link: https://lkml.kernel.org/r/20240906101825.177490-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-use-vm_special_mapping-close-functionality-fix
+++ a/kernel/events/uprobes.c
@@ -1493,9 +1493,6 @@ static void uprobe_clear_state(const str
 	delayed_uprobe_remove(NULL, vma->vm_mm);
 	mutex_unlock(&delayed_uprobe_lock);
 
-	if (!area)
-		return;
-
 	put_page(area->pages[0]);
 	kfree(area->bitmap);
 	kfree(area);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

uprobes-use-vm_special_mapping-close-functionality.patch

