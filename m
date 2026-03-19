Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C8B3469E0
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 17:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940628; cv=none; b=QaQLzlWnDqk6vAxb4+OH6/ytnaOMoEHIE29hz+eNffCfhi/LeKgWAzyMwAYeyZ5hfb6VMrhqgvkRBsEGcxphqb74e6TAFX9Uu3Gf7vPV9yC9CcfXp7Bjz99DPi4/7slVCfvgfWt6lk0U9os1tJQbYlK8axgsSqVUCDIdRAQi9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940628; c=relaxed/simple;
	bh=HPEwSI3MsRp80u05n2AMLJO/xJi/dVWfM/svByhf/To=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8xU4Hfw9DWW2QT8/7nQIMIizUjUiKNdbOAWt/25budScMsliYHeXL2lsL9IE2NDKdUOkzJCLqOazkWL9RjbhNolPUL69wFKuWexQV/AuTp0X8/+h2Ay1eGX02AZuIY2hBwJQMIie+0YUO5sVO7k4WLXA/bykwMpg8KPXaEZHvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qz59gafM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qz59gafM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773940625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=46H7s1kMwlRM1Tzv+TO9t8wHGdPvgFQeoE+HruKIbIM=;
	b=Qz59gafMc1xcyZlNjAW/wC02RDVmXqmdLvJa9SiHHiI7Rm4eAuMk+7EReXDKgNe8tPLdaM
	KbyY4m/pxb7gH0b+gwwQzxtGwW4zIhbYYDyX04t4ToUsiAFfuo33XqRSicz8kqtS3gw9tO
	7QX67i8n5OaaKtfo+kt2LlRYbXHVqZc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-IToaMOAINUmrwpzLsIu1wA-1; Thu,
 19 Mar 2026 13:17:02 -0400
X-MC-Unique: IToaMOAINUmrwpzLsIu1wA-1
X-Mimecast-MFC-AGG-ID: IToaMOAINUmrwpzLsIu1wA_1773940619
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBF2919560BC;
	Thu, 19 Mar 2026 17:16:58 +0000 (UTC)
Received: from fedora (unknown [10.44.34.186])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D54CE18001FE;
	Thu, 19 Mar 2026 17:16:50 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 19 Mar 2026 18:16:58 +0100 (CET)
Date: Thu, 19 Mar 2026 18:16:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vschneid@redhat.com,
	vincent.guittot@linaro.org, vbabka@kernel.org, surenb@google.com,
	rppt@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
	mingo@redhat.com, mhocko@suse.com, mgorman@suse.de, ljs@kernel.org,
	Liam.Howlett@oracle.com, kees@kernel.org, Kartikey406@gmail.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, david@kernel.org,
	bsegall@google.com, brauner@kernel.org
Subject: [PATCH -mm] kernel-fork-validate-exit_signal-in-kernel_clone-fix
Message-ID: <abwvgU17W8wuW2-J@redhat.com>
References: <20260316154206.C5CA4C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316154206.C5CA4C19421@smtp.kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Andrew, can you fold this trivial fixup into

	kernel-fork-validate-exit_signal-in-kernel_clone.patch

? the comment above kernel_clone() shoule be updated.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 646ae6f2ed93..a12febb8822c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2614,8 +2614,6 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
  *
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
- *
- * args->exit_signal is expected to be checked for sanity by the caller.
  */
 pid_t kernel_clone(struct kernel_clone_args *args)
 {
-- 
2.52.0


