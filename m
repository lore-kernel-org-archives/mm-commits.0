Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308F51A8F71
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739891750; cv=none; b=QyRVw5y59hlgZA+DnaKtgcqRVIkWT8Z4HHUqSAK4P3YATpnp94F6d+hBBE2TeYtCQ4JoaoU/4BdXe2OxbNHwcIti/qyIn0BtQ8037yAfjaS941tQbWCPVXXq96jxkjTwhAC8Kws9nRfEKzuw2FszDPme2yHFKwut+Em59idxVfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739891750; c=relaxed/simple;
	bh=rjgEug8Qbt1lpEJJ06SAFolYgKWqF+9ufVpvg3XrMXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DhyJErHxIM24TZ8Vf7nqTihSQJvvoo4W+2ILPSrlh0P523nwjvBwyrxMnhClkpvTCsEYLaESed96lcVKjwg2Jj0i+o4T4hA71jXvik67D5RWkrcKAupqMMNQyfd8n9aG4f1xuTUFMJaFVbOIy2NtgrDF+eRLYO/eSd2h7MPI8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1tkPK5-0005hi-OA; Tue, 18 Feb 2025 16:15:45 +0100
Message-ID: <7cf75d81-7113-4b62-9db2-76bc9f77cde1@pengutronix.de>
Date: Tue, 18 Feb 2025 16:15:43 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 regulator-allow-user-configuration-of-hardware-protection-action.patch added
 to mm-nonmm-unstable branch
To: Mark Brown <broonie@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tzungbi@kernel.org, teknoraver@meta.com,
 serge@hallyn.com, rui.zhang@intel.com, robh@kernel.org, rafael@kernel.org,
 mazziesaccount@gmail.com, lukasz.luba@arm.com, lgirdwood@gmail.com,
 kernel@pengutronix.de, groeck@chromium.org, festevam@denx.de,
 daniel.lezcano@linaro.org, corbet@lwn.net, bleung@chromium.org
References: <20250218025407.51C9FC4CED1@smtp.kernel.org>
 <Z7ShszudrCbadXuL@finisterre.sirena.org.uk>
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <Z7ShszudrCbadXuL@finisterre.sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: mm-commits@vger.kernel.org

Hello Mark,

On 18.02.25 16:05, Mark Brown wrote:
> On Mon, Feb 17, 2025 at 06:54:06PM -0800, Andrew Morton wrote:
>>
>> The patch titled
>>      Subject: regulator: allow user configuration of hardware protection action
>> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>>      regulator-allow-user-configuration-of-hardware-protection-action.patch
> 
> This patch was posted less than 24 hours ago, after I last looked at my
> mail yesterday.  There's not been *any* chance for review here, I'm
> still triaging my inbox today.

Did you receive v2 of my patch series[1] that was sent last month?

The only difference in this particular patch between v2 and v3 are
two Reviewed-by tags that were posted in the meantime.

I haven't sent out many patches crossing subsystems before, so please
let me know how to better handle this in future.

[1]: https://lore.kernel.org/all/20250113-hw_protection-reboot-v2-8-161d3fc734f0@pengutronix.de/

Thanks,
Ahmad
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
