Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B5A2DC323;
	Tue, 27 Jan 2026 02:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482663; cv=none; b=mWYYbJRp1JCAyElZ0556QIE6Ilglo0O7AKDO+ZSEFsTvdoUSvPlUokKibP5kAV//7VPOLZOHhWmI5hZpR3m521TE7MjKDc0yK8u32CXe7BSeeKoVR8T4ch7PIZwW+9pKermYASOolr7KYFWUZ82bTr/A735w2nEPhPUbrczSKnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482663; c=relaxed/simple;
	bh=buGxmtU85jDj4rVJNcKQzToo2s/A0kRTPdKs9Zv9AjA=;
	h=Date:To:From:Subject:Message-Id; b=grFLcNtyCT5bv7gBgaNEuNdSxBn3myBIKXrcZWGVqte62Duq7jEER5uP4CCqnShxVGQ2bHXZmJmQ3u2zibyRKlBEjFZ14qqwHHKCtryj8a6Z7zjva3A9r/qfYckNg1fBV3k1zPJM/vloV92RmVaWJyyMwNp3lLdHJOxwsZ+PPUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yrXuP/Tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yrXuP/Tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B631C116C6;
	Tue, 27 Jan 2026 02:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482663;
	bh=buGxmtU85jDj4rVJNcKQzToo2s/A0kRTPdKs9Zv9AjA=;
	h=Date:To:From:Subject:From;
	b=yrXuP/TvxOn9YrlgB2/vHWj9gQhaPmNISwxQ404G/Q+K2j3il0C3+Dvy98tA61kNO
	 qvxvx8VzZhLduMebVFbHzgMEtLRjKja2DHqGFvRdJ1tnmD4C1TKUviSc0uaqmF88dL
	 mZtHPTFnv0qF09nEAQx/BkIPEZAJMcrPsjg3kypA=
Date: Mon, 26 Jan 2026 18:57:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,miklos@szeredi.hu,joannelkoong@gmail.com,bernd@bsbernd.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] flex_proportions-make-fprop_new_period-hardirq-safe.patch removed from -mm tree
Message-Id: <20260127025743.1B631C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: flex_proportions: make fprop_new_period() hardirq safe
has been removed from the -mm tree.  Its filename was
     flex_proportions-make-fprop_new_period-hardirq-safe.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: flex_proportions: make fprop_new_period() hardirq safe
Date: Wed, 21 Jan 2026 12:27:30 +0100

Bernd has reported a lockdep splat from flexible proportions code that is
essentially complaining about the following race:

<timer fires>
run_timer_softirq - we are in softirq context
  call_timer_fn
    writeout_period
      fprop_new_period
        write_seqcount_begin(&p->sequence);

        <hardirq is raised>
        ...
        blk_mq_end_request()
	  blk_update_request()
	    ext4_end_bio()
	      folio_end_writeback()
		__wb_writeout_add()
		  __fprop_add_percpu_max()
		    if (unlikely(max_frac < FPROP_FRAC_BASE)) {
		      fprop_fraction_percpu()
			seq = read_seqcount_begin(&p->sequence);
			  - sees odd sequence so loops indefinitely

Note that a deadlock like this is only possible if the bdi has configured
maximum fraction of writeout throughput which is very rare in general but
frequent for example for FUSE bdis.  To fix this problem we have to make
sure write section of the sequence counter is irqsafe.

Link: https://lkml.kernel.org/r/20260121112729.24463-2-jack@suse.cz
Fixes: a91befde3503 ("lib/flex_proportions.c: remove local_irq_ops in fprop_new_period()")
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Bernd Schubert <bernd@bsbernd.com>
Link: https://lore.kernel.org/all/9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com/
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_proportions.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/flex_proportions.c~flex_proportions-make-fprop_new_period-hardirq-safe
+++ a/lib/flex_proportions.c
@@ -64,13 +64,14 @@ void fprop_global_destroy(struct fprop_g
 bool fprop_new_period(struct fprop_global *p, int periods)
 {
 	s64 events = percpu_counter_sum(&p->events);
+	unsigned long flags;
 
 	/*
 	 * Don't do anything if there are no events.
 	 */
 	if (events <= 1)
 		return false;
-	preempt_disable_nested();
+	local_irq_save(flags);
 	write_seqcount_begin(&p->sequence);
 	if (periods < 64)
 		events -= events >> periods;
@@ -78,7 +79,7 @@ bool fprop_new_period(struct fprop_globa
 	percpu_counter_add(&p->events, -events);
 	p->period += periods;
 	write_seqcount_end(&p->sequence);
-	preempt_enable_nested();
+	local_irq_restore(flags);
 
 	return true;
 }
_

Patches currently in -mm which might be from jack@suse.cz are


