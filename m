Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B0242AA9;
	Tue, 14 Apr 2026 05:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776144891; cv=none; b=bg7BNRrx8Kq+yW3SRUqyWT2pxv7+CqhpdGt8mIqWl8qV/feCuAmt8UXCXmfJivIitjBToMlMir0REeOobtwPTjvNJjreMraqqh3BC/GQb8IIgQQaEfV/fCys1KBbqcDZ0gFtc26jD4NFRzWF14khU+GDzw5QoyFEL5WK9F36yeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776144891; c=relaxed/simple;
	bh=00QV4wG5q+k4VaF5QPPLAeuFbELO7QKOtTtsQtHWIqY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RlzY1UvlvdoGau6H7DcC5Q8HyUfdJX2OfIdz/KoLzP50KT0xPFqzMIPla50kCsxXw2DTlKVvMn52of8xNqnjnok6iRRCwvOLCPjGgTUbbXXtKuyfqn9YEs7VFP9wOWHHKhgCIUlyxuf3ZcNIa+TgcXk1ky7dXAqSzop/S5EiOno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Es0iXft5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Es0iXft5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27179C19425;
	Tue, 14 Apr 2026 05:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776144890;
	bh=00QV4wG5q+k4VaF5QPPLAeuFbELO7QKOtTtsQtHWIqY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Es0iXft56IBKC5yKJtA44+umNVTx25yiv4hl5t0CxISjEOG7uvMNw7HiEZ+di0MP9
	 5OdD3cgmSqMfJSFCJCiHZqhA2rMMTZYFfWJBjBpGbKrJrQRh2ZyQGFGU/aRHSWagrK
	 HhG3F9EZKzrAD+v4NVIo05HynJyojm1yoVFUZHJg=
Date: Mon, 13 Apr 2026 22:34:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tejas bharambe <tejas.bharambe@outlook.com>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>, "piaojun@huawei.com"
 <piaojun@huawei.com>, "mark@fasheh.com" <mark@fasheh.com>,
 "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
 "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
 "jlbec@evilplan.org" <jlbec@evilplan.org>, "heming.zhao@suse.com"
 <heming.zhao@suse.com>, "gechangwei@live.cn" <gechangwei@live.cn>
Subject: Re: [to-be-updated]
 ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch removed
 from -mm tree
Message-Id: <20260413223444.aa4a3c6df45ed6bb18bac168@linux-foundation.org>
In-Reply-To: <JH0PR06MB66327896972223B31B527A1089242@JH0PR06MB6632.apcprd06.prod.outlook.com>
References: <20260411194328.0CEB1C2BCAF@smtp.kernel.org>
	<JH0PR06MB66327896972223B31B527A1089242@JH0PR06MB6632.apcprd06.prod.outlook.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 Apr 2026 22:34:28 +0000 tejas bharambe <tejas.bharambe@outlook.com> wrote:

> Any action item on my end?

Nope!  I dropped v1, added v2.
