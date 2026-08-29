Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FF413D891
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788046326; cv=none; b=VVvd0yZipQQ5qIRT1JAvZus9MIw1OYfB8TUi586/WQJ53IrU1BfKdfZDrNpSM/LniJV+Kht4u8VnalpvHekJe810QBInAKUivo9mnklWKZxtBL89dIePon0EUNlLE9qz7BA3W9F1ypNrxObL145CftEN/JxI6NzXqJWy5sChIHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788046326; c=relaxed/simple;
	bh=A5DEr/+U7S9Oq3YZnng7upNtYGRzq8Xzelc3CwPAb1I=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=kL/oavjjLB3JmIoIziqiDTzAJx22ZQYuN1gCfcxQiVdOBphX5KCXl4TEqAXPZ25vPNPe92VPxLOCDNFYmQr8zqTe/VcnuVgHR+KV4JUxfDmyAMNPinemfT2vM6GnXzIfE1huovU3iPLTpwEUd8qdpzG87KgnQ1PnY7p7lEqtPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=ANPebS6x; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=sBquOLnq; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="ANPebS6x";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="sBquOLnq"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788046322; bh=5Dufz/7mS57nQT4tUGx3X5J
	Em3U5R56kNaMTgcFvrRo=; b=ANPebS6xs2F+3OqYTAo30c+r//E5VMx3h5IQDNf9Bhfuqc8eNL
	xR/HMBGntvdkb+vJEVdpsNrwT7ipnk72jwiF8NsjyYyazxdsodCPz3noeJcU9IeTbffrn+KF12D
	10kdJXLipXdIgwOgi2XjgBfR23l/0uLpGsKJ/DAbT6f1HHPbTeFXWSEN9UmJOderfn6aDu7zTc/
	EHSdDU9AjVPDJI3Web/k1DQHrX6t4JveRgy3ZmuCt4o5OffQGhiDD7OrahtYFta0fo4P/W+/kHu
	XFWrOw6ZPOidIhX2ZntRBRtnZH5tH06+wzRqEYTnqxvnt6gAfZjJ5/BXdXebsH19kng==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788046322; bh=5Dufz/7mS57nQT4tUGx3X5J
	Em3U5R56kNaMTgcFvrRo=; b=sBquOLnq5sp0GEtVqD0FlwWGKS1bNmkr5B2IFdxHlrLvUm0MjJ
	W8IwLXzv1cGaBaTqWSVv9oyY1oYPQXLVlDDg==;
Date: Sun, 30 Aug 2026 00:32:04 +0100
From: Bradley Morgan <brads@mainlining.org>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mm-commits@vger.kernel.org, pmladek@suse.com, mhiramat@kernel.org,
 lance.yang@linux.dev, david.laight.linux@gmail.com, atomlin@atomlin.com
Subject: =?US-ASCII?Q?Re=3A_+_hung=5Ftask-reset-warning-budget-when-problem-g?=
 =?US-ASCII?Q?ets-resolved=2Epatch_added_to_mm-nonmm-unstable_branch?=
In-Reply-To: <20260829162541.50f77ff5de42c35b7eadffe1@linux-foundation.org>
References: <20260829224704.C3D0B1F000E9@smtp.kernel.org> <1C7F9139-85AC-44C5-A1D2-6C7429C84661@mainlining.org> <20260829162541.50f77ff5de42c35b7eadffe1@linux-foundation.org>
Message-ID: <30D6FBCC-D7E9-41F9-94FD-393F7E10926F@mainlining.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 30 August 2026 00:25:41 BST, Andrew Morton <akpm@linux-foundation.org>
wrote:
>On Sat, 29 Aug 2026 23:48:39 +0100 Bradley Morgan <brads@mainlining.org>
>wrote:
>
>> >Link:
>https://lore.kernel.org/20260829145321.18423-1-atomlin@atomlin.com
>> >Link:
>https://lore.kernel.org/20260829145321.18423-2-atomlin@atomlin.com
>> >Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
>> >Suggested-by: Petr Mladek <pmladek@suse.com>
>> >Suggested-by: Lance Yang <lance.yang@linux.dev>
>> >Tested-by: Lance Yang <lance.yang@linux.dev>
>> >Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> >Cc: Bradley Morgan <brads@mainlining.org>
>> 
>> 
>> 
>> Andrewwwwww, your gonna killlll meeee but can u plssss add my
>taggggg.....
>> My client had issues.
>
>If you mean you want a Reviewed-by: in there then please send one!
Oh fiddlesticks

Reviewed-by: Bradley Morgan <brads@mainlining.org>

--- Thanks!
https://lore.kernel.org/all/EE579805-42F2-4C58-B752-F28779EEB717@grrlz.net/
