Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7B313C900
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 08:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714119020; cv=none; b=LPa4By6ueNolfrxToMeVdNRAxPvVRjarbiV4lhc955q82VR8rghDwxxwYqdj2CeMNyE2IozZFKns3DC1hvLwKfmaLwRbaI97d0rajUU1clMt7vLO2+Md/XlUiOD7zxhiTMxTin4kIJxceYDjnvY2PeRJ5L6RAPwB+PEmz5/UOv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714119020; c=relaxed/simple;
	bh=j6AwAjueAe3iipKnG+ykarr6MlypfgbGm7YVQ6Beqp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uGWIKuzQfz+j6DXT8pl8dzFIQ9Lk0suIjNRzrusujmkeODENhC//mrSLUvDOGCVGhNFQ0UdR8ccvzfky/RIKdFYC3Chc/pVMk0Al0j5+n9sKTQCcp4zZqePpCDuUUPZvP7wZKeaP2lQB5XCAW0upllc4rNfWge2VOwgNxCxjpsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V4msU9AR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V4msU9AR"
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q7xdcS002111;
	Fri, 26 Apr 2024 08:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=poalhvVRgF2EWicSSmzKh9U0UdkBzTzooZlRexDCAeo=;
 b=V4msU9ARIJlcyCxYQpkyAefHfB5PAJtqoN4aT7d0SyPbTui5hdqkWvFXJTecJafRGgsz
 gcgfpX0ekH5GGpz9S0mYUy1twVDmhD4xAP3dP04myjvfIU7aUm/MQk6qWRaDE63cNEUL
 Td8Ev7Yovnkfpkkcp8d5sODMpvKtspMEmTFH3nPyBaKU0BGG+nF9R+Ymfvo0xkvDcRk0
 3bWEWtDzEURL6q9wSXgjzvsMOKpC1yy434Z7/BR15qm/Eot7wDflzgk74FZa0/GGf+fC
 b91bJPxnrqBHRO1YCrDOLjW6bRBEKObossDLqMPEZzXdQQR7NpGSLwlYiyLzsUOy/z1U EQ== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xr8c0g0vx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Apr 2024 08:10:13 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q7IAS4005736;
	Fri, 26 Apr 2024 08:10:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmx3cwcma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Apr 2024 08:10:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43Q8A72v19399094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Apr 2024 08:10:09 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83FB52004D;
	Fri, 26 Apr 2024 08:10:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE6F62004B;
	Fri, 26 Apr 2024 08:10:06 +0000 (GMT)
Received: from osiris (unknown [9.171.34.163])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 26 Apr 2024 08:10:06 +0000 (GMT)
Date: Fri, 26 Apr 2024 10:10:05 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, wintera@linux.ibm.com, twinkler@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        arnd@arndb.de, agordeev@linux.ibm.com, nathan@kernel.org
Subject: Re: [merged mm-nonmm-stable]
 s390-netiucv-remove-function-pointer-cast.patch removed from -mm tree
Message-ID: <20240426081005.8950-C-hca@linux.ibm.com>
References: <20240426040814.160C2C113CD@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426040814.160C2C113CD@smtp.kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V7C3EwS8TlOE5EhAYCpJ8aK0504fGix7
X-Proofpoint-ORIG-GUID: V7C3EwS8TlOE5EhAYCpJ8aK0504fGix7
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-26_07,2024-04-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404260051

On Thu, Apr 25, 2024 at 09:08:13PM -0700, Andrew Morton wrote:
> The quilt patch titled
>      Subject: s390/netiucv: remove function pointer cast
> has been removed from the -mm tree.  Its filename was
>      s390-netiucv-remove-function-pointer-cast.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Nathan Chancellor <nathan@kernel.org>
> Subject: s390/netiucv: remove function pointer cast
> Date: Wed, 17 Apr 2024 11:24:37 -0700
> 
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
> 
>   drivers/s390/net/netiucv.c:1716:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>    1716 |                 dev->release = (void (*)(struct device *))kfree;
>         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI. The
> comment is not really relevant after this change, so remove it.
> 
> Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Alexandra Winter <wintera@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thorsten Winkler <twinkler@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/s390/net/netiucv.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

And this one should be dropped as well.
