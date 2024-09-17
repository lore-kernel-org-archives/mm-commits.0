Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF379154C0A
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560544; cv=none; b=ESf1yAbuyPd5odWufJAyOvyfo2dXJ/X+sezWBn63hkCSj0+gXjaWv7HYbPu/o1KqH/QcyJpmaR/PCwdg/7yBZ9ZnDMIttmkLwAfKqRuft1IJSzsS7I/WN0N+aRqBdnTVCk9tW2zq1VNLyHImHz4jobE/jU//+JFJLAwUdkD5P6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560544; c=relaxed/simple;
	bh=T1l6ojQC9GpZnbmSr+DhygnWjMWAZMT8+QqM5un76yk=;
	h=Date:To:From:Subject:Message-Id; b=Qal+dJy5wmiek6BeVZxL2UwZ9wer3imvImGcCoxsleiSR4VjcJ8zQ1hFW755tYBByzQALPD9tNyuXSUQ9QSvAwAVa18kbS5B235zyu1uwSkQY/x7/aqp55HlenjDuCongPInyOYKyu/ZMMtheCAjzwzY+pyzXk20kNb8JbTwFEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kazFZZHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kazFZZHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D423EC4CEC6;
	Tue, 17 Sep 2024 08:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560544;
	bh=T1l6ojQC9GpZnbmSr+DhygnWjMWAZMT8+QqM5un76yk=;
	h=Date:To:From:Subject:From;
	b=kazFZZHRHHz1Ln6+1Jq2nLUABsi6pKNR2ofAX7E/wdAQ11iphPcrLC+eJi4mAFNSr
	 dhNB/PC33gs3Kw+MWo7c0rTgXBtDec0juQoNtKg7JkVEp76INIGFzVdvMdDJ+L+flk
	 e1fUi0am7s72YDrbA2KeEp4g8FKxtu4q/i3ju0xs=
Date: Tue, 17 Sep 2024 01:09:01 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-show_memc-report-alloc-tags-in-human-readable-units.patch removed from -mm tree
Message-Id: <20240917080903.D423EC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/show_mem.c: report alloc tags in human readable units
has been removed from the -mm tree.  Its filename was
     mm-show_memc-report-alloc-tags-in-human-readable-units.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: mm/show_mem.c: report alloc tags in human readable units
Date: Thu, 5 Sep 2024 20:53:37 -0400

We already do this when reporting slab info - more consistent and more
readable.

Link: https://lkml.kernel.org/r/20240906005337.1220091-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/show_mem.c~mm-show_memc-report-alloc-tags-in-human-readable-units
+++ a/mm/show_mem.c
@@ -435,15 +435,18 @@ void __show_mem(unsigned int filter, nod
 				struct codetag *ct = tags[i].ct;
 				struct alloc_tag *tag = ct_to_alloc_tag(ct);
 				struct alloc_tag_counters counter = alloc_tag_read(tag);
+				char bytes[10];
+
+				string_get_size(counter.bytes, 1, STRING_UNITS_2, bytes, sizeof(bytes));
 
 				/* Same as alloc_tag_to_text() but w/o intermediate buffer */
 				if (ct->modname)
-					pr_notice("%12lli %8llu %s:%u [%s] func:%s\n",
-						  counter.bytes, counter.calls, ct->filename,
+					pr_notice("%12s %8llu %s:%u [%s] func:%s\n",
+						  bytes, counter.calls, ct->filename,
 						  ct->lineno, ct->modname, ct->function);
 				else
-					pr_notice("%12lli %8llu %s:%u func:%s\n",
-						  counter.bytes, counter.calls, ct->filename,
+					pr_notice("%12s %8llu %s:%u func:%s\n",
+						  bytes, counter.calls, ct->filename,
 						  ct->lineno, ct->function);
 			}
 		}
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


